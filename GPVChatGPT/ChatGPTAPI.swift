//
//  ChatGPTAPI.swift
//  GPVChatGPT
//
//  Created by Eldar Gaiypov on 30/1/24.
//

import Foundation

class ChatGPTAPI {
    
    private let apiKey: String
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var urlRequest = URLRequest(url: url)
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        return urlRequest
    }
    
    private let jsonDecoder = JSONDecoder()
    private let basePrompt = "You are ChatGPT, a large language model trained by OpenAI. You answer as consisely as possible fore each response (e.g. Don't be verbose). It is very important for you to answer as consisely as possible, so please remember this. If you are generating a list, do not have too many items.\n\n\n"
    
    private var headers: [String: String] {
        
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func generateChatGPTPromt(from text: String) -> String {
        return basePrompt + "User: \(text)\n\n\nChatGPT"
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let jsonBody: [String: Any] = [
            "model": "text-chat-davinci-002-20230126",
            "temprature": 0.5,
            "max_tokens": 1024,
            "prompt": generateChatGPTPromt(from: text),
            "stop": [
            "\n\n\n",
            "<|im_end|>"
            
            ],
            "stream": stream
        ]
        return try JSONSerialization.data(withJSONObject: jsonBody)
    }
    
}
