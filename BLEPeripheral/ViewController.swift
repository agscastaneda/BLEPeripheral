//
//  ViewController.swift
//  BLEPeripheral
//
//  Created by Agustin Castaneda on 18/08/20.
//  Copyright © 2020 Agustin Castaneda. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 20)
        label.text =  "BLE Peripheral"
        label.textColor = .black
        return label
    }()

    private lazy var updateValueButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(updateValue), for: .touchUpInside)
        button.setTitle("Update Value", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()

    private var peripheralManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupComponents()
        addConstraints()

        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }

    private func setupComponents() {
        view.addSubviewForAutoLayout(titleLabel)
        view.addSubviewForAutoLayout(updateValueButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            updateValueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            updateValueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateValueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            updateValueButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }

    private let serviceUUID = CBUUID(string: "1DE118A8-2634-4BE3-9140-44BEA1259798")

    //Create characteristics
    let char1 =  CBMutableCharacteristic(type: CBUUID(nsuuid: UUID()), properties: [.write], value: nil, permissions: [.writeable])

    let char2 = CBMutableCharacteristic(type: CBUUID(nsuuid: UUID()), properties: [.notify], value: nil, permissions: [.readable])

    func addServices() {

        //Create Service
        let myService = CBMutableService(type: serviceUUID, primary: true)

        myService.characteristics = [char1, char2]
        peripheralManager.add(myService)

        startAdvertising()

    }

    func startAdvertising() {
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "agscastaneda", CBAdvertisementDataServiceUUIDsKey : [serviceUUID]])
    }

    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }

    @objc func updateValue() {
        if let data = "123".data(using: .utf8) {
            print(data.hexEncodedString())
            peripheralManager.updateValue(data, for: char2, onSubscribedCentrals: nil)
        }
    }

}


extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheralManager.state {

        case .unknown:
            print("Bluetooth unknown")
        case .resetting:
            print("Bluetooth resetting")
        case .unsupported:
            print("Bluetooth unsupported")
        case .unauthorized:
            print("Bluetooth unauthorized")
        case .poweredOff:
            print("Bluetooth poweredOff")
        case .poweredOn:
            print("Bluetooth poweredOn")
            addServices()
        @unknown default:
            fatalError()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("didReceiveWrite")

        if let value = requests.first?.value{
            peripheral.respond(to: requests.first!, withResult: .success)
            print("✍🏾\(value.hexEncodedString())")
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceiveRead")
        request.value = "Hola".data(using: .utf8)
            peripheralManager.respond(to: request, withResult: .success)
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        print("Start Advertising Succeeded!")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }

        print("service: \(service)")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("subscribed to: \( characteristic.uuid)")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("unsubscribed to: \( characteristic.uuid)")
    }
}

