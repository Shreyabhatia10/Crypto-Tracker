//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by Shreya Bhatia on 12/05/22.
//

import UIKit
import LocalAuthentication

private let headerHeight = 100.0
private let networthHeight = 45.0

class CryptoTableViewController: UITableViewController, CoinDataDelegate {
    
    var amountLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinData.shared.getPrices()
        
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            updateSecureButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        displayNetWorth()
        tableView.reloadData()
    }

    func updateSecureButton() {
        if UserDefaults.standard.bool(forKey: "secure") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unsecure App", style: .plain, target: self, action: #selector(secureTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Secure App", style: .plain, target: self, action: #selector(secureTapped))
        }
    }
    
    @objc func secureTapped() {
        if UserDefaults.standard.bool(forKey: "secure") {
            UserDefaults.standard.set(false, forKey: "secure")
        } else {
            UserDefaults.standard.set(true, forKey: "secure")
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoinData.shared.coins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        let coin = CoinData.shared.coins[indexPath.row]
        cell.textLabel?.text = "\(coin.symbol)  -   \(coin.priceAsString())"
        
        if coin.amount != 0.0 {
            cell.detailTextLabel?.text = "\(coin.amount)"
        }
        
        cell.imageView?.image = coin.image
        return cell
    }

    func newPrices() {
        displayNetWorth()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinDataViewController()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        headerView.backgroundColor = .white
        
        let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: networthHeight))
        netWorthLabel.text = "My Crypto Net Worth"
        netWorthLabel.textAlignment = .center
        headerView.addSubview(netWorthLabel)
        
        amountLabel.frame = CGRect(x: 0, y: networthHeight, width: view.frame.size.width, height: networthHeight)
        amountLabel.font = UIFont.boldSystemFont(ofSize: 60)
        amountLabel.textAlignment = .center
        displayNetWorth()
        headerView.addSubview(amountLabel)
        
        return headerView
    }
    
    private func displayNetWorth() {
        amountLabel.text = CoinData.shared.netWorthAsString()
    }
}
