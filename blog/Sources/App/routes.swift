import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("_demo") { req -> Future<String> in
        
        let post = Post(title: "Hello Fluent", body: "This is how you set up a database using Vapor Fluent", author: "ben")
        
        return post.save(on: req).map { post in
            return "Created Post with ID: \(post.id!)"
        }
    }
    
    // PUT /posts/1/publish
    router.put("posts", Post.parameter, "publish") { req -> Future<Post> in
        
        try req.parameters.next(Post.self).flatMap { post in
            post.publishedAt = Date()
            return post.save(on: req)
        }
    }
    
    router.delete("posts", Post.parameter) { req -> Future<String> in
        guard let futurePost = try? req.parameters.next(Post.self) else {
            throw Abort(.badRequest)
        }
        
        return futurePost.flatMap { post in
            return post.delete(on: req).map {
                return "deleted post: \(post.id!)"
            }
        }
    }
}
