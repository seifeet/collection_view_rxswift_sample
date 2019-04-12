import RxDataSources

struct FeedEntity: IdentifiableType, Equatable {
    let id: Int
    let image: URL
    let likeCount: Int
    let liked: Bool

    var identity: Int {
        return id
    }

}

extension FeedEntity {

    func copy(liked: Bool) -> FeedEntity {
        return FeedEntity(
            id: self.id,
            image: self.image,
            likeCount: liked ? self.likeCount+1 : self.likeCount-1,
            liked: liked
        )
    }

}
