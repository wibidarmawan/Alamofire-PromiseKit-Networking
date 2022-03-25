//
//  ViewController.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 04/03/22.
//

import UIKit
import PromiseKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var tfNumber: UITextField!
    
    private lazy var session: Session = {
        return ConnectionSettings.sessionManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnPressed(_ sender: UIButton) {
        handleButtonPress1()
    }
    
    func handleButtonPressed(){
        guard let numberString = tfNumber.text,
              let number = Int(numberString) else {return}
        let apiRouterStructure = ApiRouterStructure(apiRouter: .todos(number: number))
        let todosPromise: Promise<TodoModel> = session.request(apiRouterStructure)
        
        firstly {
            todosPromise
        }
        .then{[weak self] todo -> Promise<TodoModel> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLabel.text = todo.title
            return Promise<TodoModel>.value(todo)
        }
        .then{ [weak self] todo -> Promise<TodoModel> in
            guard let self = self else { throw InternalError.unexpected }
            let nextID = todo.id + 1
            let apiRouterStructure = ApiRouterStructure(apiRouter: .todos(number: nextID))
            let todosPromiseNext: Promise<TodoModel> = self.session.request(apiRouterStructure)
            return todosPromiseNext
        }
        .then { [weak self] todoNext -> Promise<TodoModel> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLabel.text = self.myLabel.text! + "\n" + todoNext.title
            let nextID = todoNext.id + 2
            let apiRouterStructure = ApiRouterStructure(apiRouter: .todos(number: nextID))
            let todosPromiseNext: Promise<TodoModel> = self.session.request(apiRouterStructure)
            return todosPromiseNext
        }
        .then {[weak self] todoNext -> Promise<Void> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLabel.text = self.myLabel.text! + "\n" + todoNext.title
            return Promise()
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            print("there was an error")
            self.myLabel.text = "there was an error"
        }
        .finally {
            print("finally done")
        }
    }
    
}

extension ViewController{
    func handleButtonPress1(){
        guard let numberString = tfNumber.text,
              let number = Int(numberString) else {return}
        let postRequestModel = PostRequestModel(title: "Hello Title", body: "Post Body", userID: 2)
        let apiRouterStructure = ApiRouterStructure(apiRouter: .post(postRequestModel: postRequestModel))
        let postPromise: Promise<PostModel> = session.request(apiRouterStructure)
        
        firstly{
            postPromise
        }
        .then { [weak self] post -> Promise<PostModel> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLabel.text = "UserID: \(post.userID) \(post.body)"
            return Promise<PostModel>.value(post)
        }
        .then {[weak self] post -> Promise<TodoModel> in
            guard let self = self else { throw InternalError.unexpected }
            let apiRouterStructure = ApiRouterStructure(apiRouter: .todos(number: number))
            let todosPromise: Promise<TodoModel> = self.session.request(apiRouterStructure)
            return todosPromise
        }
        .then {[weak self] todo -> Promise<Void> in
            guard let self = self else { throw InternalError.unexpected }
            self.myLabel.text = self.myLabel.text! + "\(todo.title)"
            return Promise()
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            print(error.localizedDescription)
            self.myLabel.text = "there was an error"
        }
        .finally {
            print("done post")
        }
    }
}

