import Foundation
import UIKit
import CoreLocation
import MessageKit
import AVFoundation


struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}


private struct CoordinateItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

    init(imageURL: URL) {
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage(imageLiteralResourceName: "image_message_placeholder")
    }
}

private struct MockAudioItem: AudioItem {

    var url: URL
    var size: CGSize
    var duration: Float

    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        // compute duration
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }

}

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
    
}

struct MockLinkItem: LinkItem {
    let text: String?
    let attributedText: NSAttributedString?
    let url: URL
    let title: String?
    let teaser: String
    let thumbnailImage: UIImage
}

internal struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind

    var user: MockUser

    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }

    init(text: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }

    init(image: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(imageURL: URL, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(imageURL: imageURL)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(location: CLLocation, user: MockUser, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
    }

    init(emoji: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
    }

    init(audioURL: URL, user: MockUser, messageId: String, date: Date) {
        let audioItem = MockAudioItem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
    }

    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
    }

    init(linkItem: LinkItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .linkPreview(linkItem), user: user, messageId: messageId, date: date)
    }
}

// MARK: - 샘플데이터



final internal class SampleData {

    static let shared = SampleData()

    private init() {}

    enum MessageTypes: String, CaseIterable {
        case Text
        case AttributedText
        case Photo
        case PhotoFromURL = "Photo from URL"
        case Video
        case Emoji
        case Location
        case Url
        case Phone
        case Custom
        case ShareContact
    }

    let system = MockUser(senderId: "000000", displayName: "System")
    let nathan = MockUser(senderId: "000001", displayName: "Nathan Tannar")
    let steven = MockUser(senderId: "000002", displayName: "Steven Deutsch")
    let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")

    lazy var senders = [nathan, steven, wu]
    
    lazy var contactsToShare = [
        MockContactItem(name: "System", initials: "S"),
        MockContactItem(name: "Nathan Tannar", initials: "NT", emails: ["test@test.com"]),
        MockContactItem(name: "Steven Deutsch", initials: "SD", phoneNumbers: ["+1-202-555-0114", "+1-202-555-0145"]),
        MockContactItem(name: "Wu Zhong", initials: "WZ", phoneNumbers: ["202-555-0158"]),
        MockContactItem(name: "+40 123 123", initials: "#", phoneNumbers: ["+40 123 123"]),
        MockContactItem(name: "test@test.com", initials: "#", emails: ["test@test.com"])
    ]

    var currentSender: MockUser {
        return steven
    }

    var now = Date()
    
    let messageImages: [UIImage] = [#imageLiteral(resourceName: "TabBar+Logo"), #imageLiteral(resourceName: "TabBar+Logo-selected")]
    let messageImageURLs: [URL] = [URL(string: "https://placekitten.com/g/200/300")!,
                                   URL(string: "https://placekitten.com/g/300/300")!,
                                   URL(string: "https://placekitten.com/g/300/400")!,
                                   URL(string: "https://placekitten.com/g/400/400")!]

    let emojis = [
        "👍",
        "😂😂😂",
        "👋👋👋",
        "😱😱😱",
        "😃😃😃",
        "❤️"
    ]
    
    let attributes = ["Font1", "Font2", "Font3", "Font4", "Color", "Combo"]
    
    let locations: [CLLocation] = [
        CLLocation(latitude: 37.3118, longitude: -122.0312),
        CLLocation(latitude: 33.6318, longitude: -100.0386),
        CLLocation(latitude: 29.3358, longitude: -108.8311),
        CLLocation(latitude: 39.3218, longitude: -127.4312),
        CLLocation(latitude: 35.3218, longitude: -127.4314),
        CLLocation(latitude: 39.3218, longitude: -113.3317)
    ]

    let linkItem: (() -> MockLinkItem) = {
        MockLinkItem(
            text: "\(Lorem.sentence()) https://github.com/MessageKit",
            attributedText: nil,
            url: URL(string: "https://github.com/MessageKit")!,
            title: "MessageKit",
            teaser: "A community-driven replacement for JSQMessagesViewController - MessageKit",
            thumbnailImage: UIImage(named: "mkorglogo")!
        )
    }

    func attributedString(with text: String) -> NSAttributedString {
        let nsString = NSString(string: text)
        var mutableAttributedString = NSMutableAttributedString(string: text)
        let randomAttribute = Int(arc4random_uniform(UInt32(attributes.count)))
        let range = NSRange(location: 0, length: nsString.length)
        
        switch attributes[randomAttribute] {
        case "Font1":
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
        case "Font2":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: range)
        case "Font3":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Font4":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Color":
            mutableAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)
        case "Combo":
            let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
            let msg9Text = NSString(string: msg9String)
            let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))
            
            msg9AttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: msg9Text.range(of: ".attributedText()"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "bold"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "italic"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: msg9Text.range(of: "colored"))
            mutableAttributedString = msg9AttributedText
        default:
            fatalError("Unrecognized attribute for mock message")
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }

    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessageType() -> MessageTypes {
        return MessageTypes.allCases.compactMap {
            guard UserDefaults.standard.bool(forKey: "\($0.rawValue)" + " Messages") else { return nil }
            return $0
        }.random()!
    }

    // swiftlint:disable cyclomatic_complexity
    func randomMessage(allowedSenders: [MockUser]) -> MockMessage {
        let uniqueID = UUID().uuidString
        let user = allowedSenders.random()!
        let date = dateAddingRandomTime()

        switch randomMessageType() {
        case .Text:
            let randomSentence = Lorem.sentence()
            return MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        case .AttributedText:
            let randomSentence = Lorem.sentence()
            let attributedText = attributedString(with: randomSentence)
            return MockMessage(attributedText: attributedText, user: user, messageId: uniqueID, date: date)
        case .Photo:
            let image = messageImages.random()!
            return MockMessage(image: image, user: user, messageId: uniqueID, date: date)
        case .PhotoFromURL:
            let imageURL: URL = messageImageURLs.random()!
            return MockMessage(imageURL: imageURL, user: user, messageId: uniqueID, date: date)
        case .Video:
            let image = messageImages.random()!
            return MockMessage(thumbnail: image, user: user, messageId: uniqueID, date: date)
        case .Emoji:
            return MockMessage(emoji: emojis.random()!, user: user, messageId: uniqueID, date: date)
        case .Location:
            return MockMessage(location: locations.random()!, user: user, messageId: uniqueID, date: date)
        case .Url:
            return MockMessage(linkItem: linkItem(), user: user, messageId: uniqueID, date: date)
        case .Phone:
            return MockMessage(text: "123-456-7890", user: user, messageId: uniqueID, date: date)
        case .Custom:
            return MockMessage(custom: "Someone left the conversation", user: system, messageId: uniqueID, date: date)
        case .ShareContact:
            return MockMessage(contact: contactsToShare.random()!, user: user, messageId: uniqueID, date: date)
        }
    }
    // swiftlint:enable cyclomatic_complexity

    func getMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int) -> [MockMessage] {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        return messages
    }
    
    func getAdvancedMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Custom Messages
        UserDefaults.standard.set(true, forKey: "Custom Messages")
        for _ in 0..<count {
            let message = randomMessage(allowedSenders: senders)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int, allowedSenders: [MockUser], completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }

    func getAvatarFor(sender: SenderType) -> Avatar {
        let firstName = sender.displayName.components(separatedBy: " ").first
        let lastName = sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        switch sender.senderId {
        case "000001":
            return Avatar(image: UIImage(named: "AppIcon"), initials: initials)
        case "000002":
            return Avatar(image: UIImage(named: "AppIcon"), initials: initials)
        case "000003":
            return Avatar(image: UIImage(named: "AppIcon"), initials: initials)
        case "000000":
            return Avatar(image: nil, initials: "SS")
        default:
            return Avatar(image: nil, initials: initials)
        }
    }

}


// MARK: - user default

extension UserDefaults {
    
    static let messagesKey = "mockMessages"
    
    // MARK: Mock Messages
    
    func setMockMessages(count: Int) {
        set(count, forKey: UserDefaults.messagesKey)
        synchronize()
    }
    
    func mockMessagesCount() -> Int {
        if let value = object(forKey: UserDefaults.messagesKey) as? Int {
            return value
        }
        return 20
    }
    
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}


final class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?
    
    private var queuedMessage: MockMessage?
    
    private var onNewMessageCode: ((MockMessage) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var connectedUsers: [MockUser] = []
    
    private init() {}
    
    @discardableResult
    func connect(with senders: [MockUser]) -> Self {
        disconnect()
        connectedUsers = senders
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        onTypingStatusCode = nil
        onNewMessageCode = nil
        return self
    }
    
    @discardableResult
    func onNewMessage(code: @escaping (MockMessage) -> Void) -> Self {
        onNewMessageCode = code
        return self
    }
    
    @discardableResult
    func onTypingStatus(code: @escaping () -> Void) -> Self {
        onTypingStatusCode = code
        return self
    }
    
    @objc
    private func handleTimer() {
        if let message = queuedMessage {
            onNewMessageCode?(message)
            queuedMessage = nil
        } else {
            let sender = connectedUsers.random()!
            let message = SampleData.shared.randomMessage(allowedSenders: [sender])
            queuedMessage = message
            onTypingStatusCode?()
        }
    }
}



public class Lorem {
    private static let wordList = [
        "alias", "consequatur", "aut", "perferendis", "sit", "voluptatem",
        "accusantium", "doloremque", "aperiam", "eaque", "ipsa", "quae", "ab",
        "illo", "inventore", "veritatis", "et", "quasi", "architecto",
        "beatae", "vitae", "dicta", "sunt", "explicabo", "aspernatur", "aut",
        "odit", "aut", "fugit", "sed", "quia", "consequuntur", "magni",
        "dolores", "eos", "qui", "ratione", "voluptatem", "sequi", "nesciunt",
        "neque", "dolorem", "ipsum", "quia", "dolor", "sit", "amet",
        "consectetur", "adipisci", "velit", "sed", "quia", "non", "numquam",
        "eius", "modi", "tempora", "incidunt", "ut", "labore", "et", "dolore",
        "magnam", "aliquam", "quaerat", "voluptatem", "ut", "enim", "ad",
        "minima", "veniam", "quis", "nostrum", "exercitationem", "ullam",
        "corporis", "nemo", "enim", "ipsam", "voluptatem", "quia", "voluptas",
        "sit", "suscipit", "laboriosam", "nisi", "ut", "aliquid", "ex", "ea",
        "commodi", "consequatur", "quis", "autem", "vel", "eum", "iure",
        "reprehenderit", "qui", "in", "ea", "voluptate", "velit", "esse",
        "quam", "nihil", "molestiae", "et", "iusto", "odio", "dignissimos",
        "ducimus", "qui", "blanditiis", "praesentium", "laudantium", "totam",
        "rem", "voluptatum", "deleniti", "atque", "corrupti", "quos",
        "dolores", "et", "quas", "molestias", "excepturi", "sint",
        "occaecati", "cupiditate", "non", "provident", "sed", "ut",
        "perspiciatis", "unde", "omnis", "iste", "natus", "error",
        "similique", "sunt", "in", "culpa", "qui", "officia", "deserunt",
        "mollitia", "animi", "id", "est", "laborum", "et", "dolorum", "fuga",
        "et", "harum", "quidem", "rerum", "facilis", "est", "et", "expedita",
        "distinctio", "nam", "libero", "tempore", "cum", "soluta", "nobis",
        "est", "eligendi", "optio", "cumque", "nihil", "impedit", "quo",
        "porro", "quisquam", "est", "qui", "minus", "id", "quod", "maxime",
        "placeat", "facere", "possimus", "omnis", "voluptas", "assumenda",
        "est", "omnis", "dolor", "repellendus", "temporibus", "autem",
        "quibusdam", "et", "aut", "consequatur", "vel", "illum", "qui",
        "dolorem", "eum", "fugiat", "quo", "voluptas", "nulla", "pariatur",
        "at", "vero", "eos", "et", "accusamus", "officiis", "debitis", "aut",
        "rerum", "necessitatibus", "saepe", "eveniet", "ut", "et",
        "voluptates", "repudiandae", "sint", "et", "molestiae", "non",
        "recusandae", "itaque", "earum", "rerum", "hic", "tenetur", "a",
        "sapiente", "delectus", "ut", "aut", "reiciendis", "voluptatibus",
        "maiores", "doloribus", "asperiores", "repellat"
    ]
    
    /**
     Return a random word.
     
     - returns: Returns a random word.
     */
    public class func word() -> String {
        return wordList.random()!
    }
    
    /**
     Return an array of `count` words.
     
     - parameter count: The number of words to return.
     
     - returns: Returns an array of `count` words.
     */
    public class func words(nbWords: Int = 3) -> [String] {
        return wordList.random(nbWords)
    }
    
    /**
     Return a string of `count` words.
     
     - parameter count: The number of words the string should contain.
     
     - returns: Returns a string of `count` words.
     */
    public class func words(nbWords: Int = 3) -> String {
        return words(nbWords: nbWords).joined(separator: " ")
    }
    
    /**
     Generate a sentence of `nbWords` words.
     - parameter nbWords:  The number of words the sentence should contain.
     - parameter variable: If `true`, the number of words will vary between
     +/- 40% of `nbWords`.
     - returns:
     */
    public class func sentence(nbWords: Int = 6, variable: Bool = true) -> String {
        if nbWords <= 0 {
            return ""
        }
        
        let result: String = words(nbWords: variable ? nbWords.randomize(variation: 40) : nbWords)
        
        return result.firstCapitalized + "."
    }
    
    /**
     Generate an array of sentences.
     - parameter nbSentences: The number of sentences to generate.
     
     - returns: Returns an array of random sentences.
     */
    public class func sentences(nbSentences: Int = 3) -> [String] {
        return (0..<nbSentences).map { _ in sentence() }
    }
    
    /**
     Generate a paragraph with `nbSentences` random sentences.
     - parameter nbSentences: The number of sentences the paragraph should
     contain.
     - parameter variable:    If `true`, the number of sentences will vary
     between +/- 40% of `nbSentences`.
     - returns: Returns a paragraph with `nbSentences` random sentences.
     */
    public class func paragraph(nbSentences: Int = 3, variable: Bool = true) -> String {
        if nbSentences <= 0 {
            return ""
        }
        
        return sentences(nbSentences: variable ? nbSentences.randomize(variation: 40) : nbSentences).joined(separator: " ")
    }
    
    /**
     Generate an array of random paragraphs.
     - parameter nbParagraphs: The number of paragraphs to generate.
     - returns: Returns an array of `nbParagraphs` paragraphs.
     */
    public class func paragraphs(nbParagraphs: Int = 3) -> [String] {
        return (0..<nbParagraphs).map { _ in paragraph() }
    }
    
    /**
     Generate a string of random paragraphs.
     - parameter nbParagraphs: The number of paragraphs to generate.
     - returns: Returns a string of random paragraphs.
     */
    public class func paragraphs(nbParagraphs: Int = 3) -> String {
        return paragraphs(nbParagraphs: nbParagraphs).joined(separator: "\n\n")
    }
    
    /**
     Generate a string of at most `maxNbChars` characters.
     - parameter maxNbChars: The maximum number of characters the string
     should contain.
     - returns: Returns a string of at most `maxNbChars` characters.
     */
    public class func text(maxNbChars: Int = 200) -> String {
        var result: [String] = []
        
        if maxNbChars < 5 {
            return ""
        } else if maxNbChars < 25 {
            while result.count == 0 {
                var size = 0
                
                while size < maxNbChars {
                    let w = (size != 0 ? " " : "") + word()
                    result.append(w)
                    size += w.count
                }
                
                _ = result.popLast()
            }
        } else if maxNbChars < 100 {
            while result.count == 0 {
                var size = 0
                
                while size < maxNbChars {
                    let s = (size != 0 ? " " : "") + sentence()
                    result.append(s)
                    size += s.count
                }
                
                _ = result.popLast()
            }
        } else {
            while result.count == 0 {
                var size = 0
                
                while size < maxNbChars {
                    let p = (size != 0 ? "\n" : "") + paragraph()
                    result.append(p)
                    size += p.count
                }
                
                _ = result.popLast()
            }
        }
        
        return result.joined(separator: "")
    }
}

extension String {
    var firstCapitalized: String {
        var string = self
        string.replaceSubrange(string.startIndex...string.startIndex, with: String(string[string.startIndex]).capitalized)
        return string
    }
}

public extension Array {
    /**
     Shuffle the array in-place using the Fisher-Yates algorithm.
     */
    mutating func shuffle() {
        if count == 0 {
            return
        }

        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if j != i {
                self.swapAt(i, j)
            }
        }
    }
    
    /**
     Return a shuffled version of the array using the Fisher-Yates
     algorithm.
     
     - returns: Returns a shuffled version of the array.
     */
    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        
        return list
    }
    
    /**
     Return a random element from the array.
     - returns: Returns a random element from the array or `nil` if the
     array is empty.
     */
    func random() -> Element? {
        return (count > 0) ? self.shuffled()[0] : nil
    }
    
    /**
     Return a random subset of `cnt` elements from the array.
     - returns: Returns a random subset of `cnt` elements from the array.
     */
    func random(_ count: Int = 1) -> [Element] {
        let result = shuffled()
        
        return (count > result.count) ? result : Array(result[0..<count])
    }
}

extension Int {
    /**
     Return a random number between `min` and `max`.
     - note: The maximum value cannot be more than `UInt32.max - 1`
     
     - parameter min: The minimum value of the random value (defaults to `0`).
     - parameter max: The maximum value of the random value (defaults to `UInt32.max - 1`)
     
     - returns: Returns a random value between `min` and `max`.
     */
    public static func random(min: Int = 0, max: Int = Int.max) -> Int {
        precondition(min <= max, "attempt to call random() with min > max")
        
        let diff   = UInt(bitPattern: max &- min)
        let result = UInt.random(min: 0, max: diff)
        
        return min + Int(bitPattern: result)
    }
    
    public func randomize(variation: Int) -> Int {
        let multiplier = Double(Int.random(min: 100 - variation, max: 100 + variation)) / 100
        let randomized = Double(self) * multiplier
        
        return Int(randomized) + 1
    }
}

private extension UInt {
    static func random(min: UInt, max: UInt) -> UInt {
        precondition(min <= max, "attempt to call random() with min > max")
        
        if min == UInt.min && max == UInt.max {
            var result: UInt = 0
            arc4random_buf(&result, MemoryLayout.size(ofValue: result))
            
            return result
        } else {
            let range         = max - min + 1
            let limit         = UInt.max - UInt.max % range
            var result: UInt = 0
            
            repeat {
                arc4random_buf(&result, MemoryLayout.size(ofValue: result))
            } while result >= limit
            
            result = result % range
            
            return min + result
        }
    }
}
