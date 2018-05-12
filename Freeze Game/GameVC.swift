
//
//  GameVC.swift
//  Freeze Game
//
//  Created by Yasmine Ghazy on 5/1/18.
//  Copyright © 2018 Yasmine Ghazy. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    
    var timer:Timer!
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLbl: UILabel!
    var no_of_tiles : Int!
    var level : Int!
    var moves : Int!
    var gameViewWidth : CGFloat!
    var blockWidth : CGFloat!
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    var blocksArr : NSMutableArray = []
    var centersArr : NSMutableArray = []
    var empty : CGPoint!
    var rightBlocks : Int = 0
    var steps : Int = 0
    var myi : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
        self.resetAction(Any.self)
        
    }
    
    func makeBlocks(){
        
        
        blocksArr = []
        centersArr = []
        if (level == nil || level == 0){ //Easy
            no_of_tiles = 9
        }else{
            if level == 1{
               no_of_tiles = 16
            }
            else if level == 2{
                no_of_tiles = 25
            }
        }
        
        if moves == nil{
            moves = 50
        }
        
        
        
        let tiles_in_row = Int(sqrt(CGFloat(no_of_tiles)))
        
        gameViewWidth = gameView.frame.size.width
        blockWidth = gameViewWidth / CGFloat(tiles_in_row)
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        var labelNum = 1
        
        for _ in 0..<tiles_in_row{
            
            for _ in 0..<tiles_in_row{
                
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth - 4, height: blockWidth - 4)
                let block : MyLabel = MyLabel(frame: blockFrame)
                
                block.text = String(labelNum)
                block.textColor = UIColor.white
                block.textAlignment = NSTextAlignment.center
                block.font = UIFont.systemFont(ofSize: 24)
                block.backgroundColor = UIColor.darkGray
                block.isUserInteractionEnabled = true
                
                let thisCenter : CGPoint = CGPoint(x: xCenter, y: yCenter)
                block.center = thisCenter
                block.originalCenter = thisCenter
                centersArr.add(thisCenter)
               
                gameView.addSubview(block)
                blocksArr.add(block)
                
                xCenter = xCenter + blockWidth
                labelNum = labelNum + 1
            }
            
            xCenter = blockWidth / 2
            yCenter = yCenter + blockWidth
        }
        
        let lastBlock : MyLabel = blocksArr[no_of_tiles-1] as!MyLabel
        lastBlock.removeFromSuperview()
        blocksArr.removeObject(at: no_of_tiles-1)
        
    }
    
    
    @IBAction func resetAction(_ sender: Any) {
        
        
        steps = 0
        randomizeAction()
        
    }
    
    
    @IBAction func quitAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
    func randomizeAction(){
        
        let tempCentersArr : NSMutableArray = centersArr.mutableCopy() as! NSMutableArray
        for block in blocksArr{
            let randomIndex : Int = Int(arc4random())%tempCentersArr.count
            let randomCenter : CGPoint = tempCentersArr[randomIndex] as!CGPoint
            (block as! MyLabel).center = randomCenter
            tempCentersArr.removeObject(at: randomIndex)
        }
        empty = tempCentersArr[0] as! CGPoint
        
        rightBlocks = 0
        for i in 0..<no_of_tiles-1{
            let block : MyLabel = blocksArr[i]as! MyLabel
            let currentCenters : CGPoint = CGPoint(x: block.center.x , y: block.center.y )
            if (currentCenters == (centersArr[i]as! CGPoint)){
                block.backgroundColor = UIColor.blue
            }else{
                block.backgroundColor = UIColor.darkGray
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let myTouch : UITouch = touches.first!
        if (blocksArr.contains(myTouch.view as Any)){
            let block : MyLabel = (myTouch.view)! as! MyLabel
            if isAdjacent(selectedBlock: block){
                move(selectedBlock: block)
                GameOver() //Check for user win or lose
            }
            
        }
    }
    
    
    
    
    func updateRightBlocks(){
        rightBlocks = 0
        for i in 0..<no_of_tiles-1{
            let block : MyLabel = blocksArr[i]as! MyLabel
            let currentCenters : CGPoint = CGPoint(x: block.center.x , y: block.center.y )
            if (currentCenters == (centersArr[i]as! CGPoint)){
                rightBlocks = rightBlocks + 1
            }
        }

    }
    
   func move(selectedBlock : MyLabel){
        let tempCent : CGPoint = selectedBlock.center
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        
        selectedBlock.center = self.empty
        UIView.commitAnimations()
        
        
        if(selectedBlock.originalCenter == self.empty){
            selectedBlock.backgroundColor = UIColor.green
        }
        else{
            selectedBlock.backgroundColor = UIColor.darkGray
        }
        self.empty = tempCent
        self.steps = self.steps + 1
        self.timerLbl.text = String(self.steps)
        self.updateRightBlocks()

    }
    
    func isAdjacent(selectedBlock : MyLabel) -> Bool{
        let xDif : CGFloat = selectedBlock.center.x - empty.x
        let yDif : CGFloat = selectedBlock.center.y - empty.y
        let distance = sqrt(pow(xDif, 2)+pow(yDif, 2))
        if(distance == blockWidth){
            return true
        }
        else{
            return false
        }
        
    }
    
    func GameOver(){
        
        if (rightBlocks == no_of_tiles-1 || steps == moves){
            
            var title : String
            
            if(rightBlocks == no_of_tiles-1){
                title = "Congratulations, You win ^_^"
            }else{
                title = "Game Over :( "
            }
            
            let alert = UIAlertController(title: title, message: "Play again?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.resetAction(Any.self)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    func getBoard()-> NSMutableArray{
        var board : NSMutableArray = []
        var thisCenter : CGPoint

        for block in blocksArr{
            thisCenter = CGPoint(x: (block as AnyObject).center.x , y: (block as AnyObject).center.y )
            board.add(thisCenter)
        }
        thisCenter = empty
        board.add(thisCenter)
        
        return board
    }

    
    @IBAction func SolveAction(_ sender: Any) {
        //1.Return current State
        //2.Compute all possible actions
        //3.choose action based on DFS Algorithm
        //4.perform action
        
        var actions : NSMutableArray = []
        var initialState : NSMutableArray = []
        initialState = getBoard()
        
        actions = DFS(state: initialState)
        print(actions)
       // self.move(selectedBlock: self.blocksArr[0] as! MyLabel)
        for action in actions{
            print("syed action number " , action)

            if action as! Int != (no_of_tiles-1){
 
                var block : MyLabel = self.blocksArr[action as! Int] as! MyLabel              //  DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds

                //var block: MyLabel = self.blocksArr[action as! Int] as! MyLabel
                
               // self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (Timer) in
                   // self.move(selectedBlock: self.blocksArr[0] as! MyLabel)
                    
              //  }
               
                //self.timer.fire()
                self.move(selectedBlock: block)
                        
                
                }
            
            //GameOver() //Check for user win or lose
       //    }
        }

    }


    func DFS(state : NSMutableArray) -> NSMutableArray{
        
        //let max_frontier_size = 20
        let max_search_depth = 20
        var depth = 0
        
        var actions : NSMutableArray = []
        let explored : NSMutableArray = []
        let path : NSMutableArray = []
        var stack : Stack = Stack()
        var actionStack : IntStack = IntStack()
        
        stack.push(state)
        actionStack.push(no_of_tiles-1)
        
        while (stack.items != []){
            var node = stack.pop()
            var action = actionStack.pop()
            path.add(action)
            print("action : ",action)
            explored.add(node)
            
            if isGoal(board: node){
                print("Goal")
                return path
            }
            else{
                if(depth < max_search_depth){
                    actions = getActions(board: node)
                    print("Possible Actions" ,actions)
                    depth = depth + 1
                    for action in actions{
                        var new_node : NSMutableArray = performAction(board: node, action: action as! Int)
                        
                        if !isExplored(exploredArr: explored, board: new_node){
                            stack.push(new_node)
                            actionStack.push(action as! Int)
                        }
                        
                    }
                }
            }
           
        }
        return path
    }
    
    func isGoal(board : NSMutableArray)->Bool{

        var rightBlocks = 0
        for i in 0..<no_of_tiles-1{
            let block : CGPoint = board[i] as! CGPoint
            let currentCenters : CGPoint = CGPoint(x: block.x , y: block.y)
            if (currentCenters == (centersArr[i]as! CGPoint)){
                rightBlocks = rightBlocks + 1
            }
        }
        
        if (rightBlocks == no_of_tiles-1){
            return true
        }else{
            return false
        }
    }
    
    func isExplored(exploredArr : NSMutableArray, board : NSMutableArray)-> Bool{
        //var board : UILabel
        var isContain: Bool = false
        // let board : MyLabel
        for j in 0..<exploredArr.count{
            
            var rightBlocks = 0
            for i in 0..<no_of_tiles-1{
                let block : CGPoint = board[i] as! CGPoint
                let currentCenters : CGPoint = CGPoint(x: block.x , y: block.y )
                let exploredCenters : CGPoint = CGPoint(x: ((exploredArr[j] as! NSMutableArray)[i] as! CGPoint).x , y: ((exploredArr[j] as! NSMutableArray)[i] as!CGPoint).y )
                
                if (currentCenters.equalTo(exploredCenters)){
                    rightBlocks = rightBlocks + 1
                }
                
            }
            if(rightBlocks == no_of_tiles-1){
                isContain = true
            }
            
        }
        return isContain

    }
    
    func getActions(board : NSMutableArray)->NSMutableArray{
        let actions : NSMutableArray = []
        for i in 0..<no_of_tiles-1{
            if isMovable(selectedBlock: board[i] as! CGPoint, board: board){
                actions.add(i)
            }
        }
        return actions
    }
    
    func isMovable(selectedBlock : CGPoint, board : NSMutableArray) -> Bool{
        
        
        let xDif : CGFloat = selectedBlock.x - (board[no_of_tiles-1] as! CGPoint).x
        let yDif : CGFloat = selectedBlock.y - (board[no_of_tiles-1]as! CGPoint).y
        let distance = sqrt(pow(xDif, 2)+pow(yDif, 2))
        if(distance == blockWidth){
            return true
        }
        else{
            return false
        }
    }// \.func

    
    func performAction(board : NSMutableArray, action: Int)->NSMutableArray{
        
        var newBoard  : NSMutableArray = []
        var block : CGPoint
        
        for blockIndex in 0..<board.count{
            
            block = board[blockIndex] as! CGPoint
            let currentCenters : CGPoint = CGPoint(x: block.x , y: block.y )
            newBoard.add(currentCenters)
            
        }// \.For
        
        let tempCent : CGPoint = newBoard[action] as! CGPoint
        newBoard[action] = newBoard[no_of_tiles-1]
        newBoard[no_of_tiles-1] = tempCent
        return (newBoard as! NSMutableArray)

    }// \.func
    
}// \.class



class MyLabel : UILabel{
    var originalCenter : CGPoint!
    
}


//Implement Stack Data Structure of Integers

struct Stack {
    var items = [NSMutableArray]()
    mutating func push(_ item: NSMutableArray) {
        items.append(item)
    }
    mutating func pop() -> NSMutableArray {
        return items.removeLast()
    }
}
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}


 
 
 
 
 
 
