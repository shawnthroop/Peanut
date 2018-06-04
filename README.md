# Peanut

A simple framework for working with the pnut.io API.


## Authorization

First, create a `Client` value with your Client ID and Password Grant Secret. These can be found in your account's [Developer settings](https://pnut.io/dev/).

```swift
let client = Client(id: "client-id", passwordGrantSecret: "client-secret", scope: [.basic, .stream])
```

or configure the `shared` value:

```swift
Client.shared.id = "client-id"
Client.shared.passwordGrantSecret = "client-secret"
Client.shared.scope = [.basic, .stream]
```

Then request authentication using your username and password:

```swift
let request = Authorization(username: "username", password: "password", client: client).request()

URLSession.shared.data(for: request) { result in
    print(result.success)   // APIAuthorizationResponse(id: ...)
}
```
> Note: if you've configured the `shared` client simply ommit the client parameter; it will be used by default.


## Fetching Data

Fetching streams, updating objects, and performing actions are all done via the same protocol: `APIRequestable`. To fetch the posts from the global stream:

```swift
let request = Post.Stream.global.request(pagination: APIPagination(count: 10))

URLSession.shared.data(for: request) { result in
    print(result.success)   // APIObjectResponse<Post>(meta: ..., data: ...)
}
```

More complicated requests are possible. For example, it is possible to include request specific parameters, pagination, token and even an API (though only `v0` exists at the moment):

```swift
let request = Post.Stream.mentions(4).request(for: .v0, parameters: [.includeRaw: true, .includeUser: false, .includeHTML: false], token: token, pagination: APIPagination(before: 379886, count: 2))
```

> Note: Including `[.includeUser: false]` with `User.Stream` endpoints is not currently supported and an error will be thrown while parsing. 

## Composing Posts

Creating posts is similar to fetching data. For this example I’ve uploaded a photo to pnut and have a `File` value handy. Simply append a replacement value to your draft:

```swift
var draft = Post.Draft(text: "Terry Loves Yogurt!")
draft.raw.append(.oembedReplacement(id: file.id, token: file.token!))
```

Then create the request using a `Post.Mutation` endpoint:

```swift
let request = Post.Mutation.publish(draft, updatePersonalStreamMarker: true).request(parameters: [.includePostRaw: true], token: token)

URLSession.shared.data(for: request) { result in
    // ...
}
```


## Uploading Files

Similar to posts, publishing a file starts with a draft:

```swift
let draft = File.Draft(type: "com.my-app.image", mimeType: .png, name: "terry-loves-yogurt.png")
```

Then use a `File.Mutation` endpoint to publish a draft with the accompanying image data:

```swift
let image = UIImage(named: "...")!
let request = File.Mutation.publish(draft, content: UIImagePNGRepresentation(image)!, sha256: nil).request(token: token)

URLSession.shared.data(for: request) { result in
    // ...
}
```

## To-Do
This is very much a work-in-progress. Next on the list:

- User editing
- Avatar and cover image uploading
- Better documentation


## Contact

You can find me on [pnut.io](https://pnut.io/@shawn) and [Twitter](https://twitter.com/shawnthroop)
