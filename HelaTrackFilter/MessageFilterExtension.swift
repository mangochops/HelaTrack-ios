//
//  MessageFilterExtension.swift
//  HelaTrackFilter
//
//  Created by mac on 4/18/26.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        
    }
    
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
            let response = ILMessageFilterCapabilitiesQueryResponse()

            // Tell iOS we handle Transactional messages specifically for Finance
            response.transactionalSubActions = [.transactionalFinance]

            completion(response)
        }

        private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
            guard let sender = queryRequest.sender?.lowercased(),
                  let body = queryRequest.messageBody?.lowercased() else {
                return (.none, .none)
            }

            // 1. Identify Trusted Transactional Senders
            let isFinancialSender = sender.contains("mpesa") ||
                                    sender.contains("airtel") ||
                                    sender.contains("equity") ||
                                    sender.contains("247247") ||
                                    sender.contains("kcb")

            // 2. Identify Transactional Keywords (Matches your Kotlin logic)
            let hasKeywords = body.contains("confirmed") ||
                              body.contains("received") ||
                              body.contains("paid to")

            if isFinancialSender && hasKeywords {
                // This moves the message to the "Transactions" tab and sub-categorizes it as Finance
                return (.transaction, .transactionalFinance)
            }

            // If it's not a clear transaction, let the system handle it (don't block it)
            return (.none, .none)
        }
}
