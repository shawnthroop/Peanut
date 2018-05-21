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

URLSession.shared.data(for: ) { response in
    print(response.success) // Optional(APIAuthorizationResponse(id: ...))
}
```
> Note: if you've configured the `shared` client simply ommit the client parameter; it will be used by default.


## To-Do
This is very much a work-in-progress.

- Files
- Raw replacement values


## Contact

You can find me on [pnut.io](https://pnut.io/@shawn) and [Twitter](https://twitter.com/shawnthroop)
