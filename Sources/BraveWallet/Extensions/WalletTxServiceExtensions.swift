// Copyright 2021 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveCore

extension BraveWalletTxService {
  
  // Fetches all pending transactions for all given keyrings
  @MainActor func pendingTransactions(
    chainIdsForCoin: [BraveWallet.CoinType: [String]],
    for keyrings: [BraveWallet.KeyringInfo]
  ) async -> [BraveWallet.TransactionInfo] {
    await allTransactions(chainIdsForCoin: chainIdsForCoin, for: keyrings)
      .filter { $0.txStatus == .unapproved }
  }
  
  // Fetches all transactions for all given keyrings
  @MainActor func allTransactions(
    chainIdsForCoin: [BraveWallet.CoinType: [String]],
    for keyrings: [BraveWallet.KeyringInfo]
  ) async -> [BraveWallet.TransactionInfo] {
    var allTransactions: [BraveWallet.TransactionInfo] = []
    for keyring in keyrings {
      guard let keyringCoin = keyring.coin,
            let chainIdsForKeyringCoin = chainIdsForCoin[keyringCoin] else {
        continue
      }
      for chainId in chainIdsForKeyringCoin {
        for info in keyring.accountInfos {
          let transactions = await self.allTransactionInfo(
            info.coin,
            chainId: chainId, from: info.address
          )
          allTransactions.append(contentsOf: transactions)
        }
      }
    }
    return allTransactions
  }
  
  // Fetches all transactions for a given AccountInfo
  @MainActor func allTransactions(
    networks: [BraveWallet.NetworkInfo],
    for accountInfo: BraveWallet.AccountInfo
  ) async -> [BraveWallet.TransactionInfo] {
    var allTransactions: [BraveWallet.TransactionInfo] = []
    for network in networks {
      let transactions = await self.allTransactionInfo(
        accountInfo.coin,
        chainId: network.chainId,
        from: accountInfo.address
      )
      allTransactions.append(contentsOf: transactions)
    }
    return allTransactions
  }
}
