//
//  BonusRound.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 11/19/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BonusRound: SKScene
{
    var doors : [SKSpriteNode] = []
    var doorPrizes : [SKSpriteNode] = []
    var doorPressed = 0
    var xOffset : Int = 0
    
    override init(size: CGSize)
    {
        super.init(size:size)
        
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        let bonusRoundLabel = SKLabelNode(fontNamed: "Copperplate")
        bonusRoundLabel.text = "Bonus Round!"
        bonusRoundLabel.fontColor = SKColor.yellow
        bonusRoundLabel.position = CGPoint(x:Int(self.size.width)/2, y:Int(self.size.height - (self.size.height/7)))
        bonusRoundLabel.fontSize = 60
        addChild(bonusRoundLabel)
        
        let doorLabel = SKLabelNode(fontNamed: "Copperplate")
        doorLabel.text = "Pick A Door"
        doorLabel.position = CGPoint(x:Int(self.size.width)/2, y:Int(self.size.height - (self.size.height/4)))
        doorLabel.fontSize = 35
        addChild(doorLabel)
        
        for i in 0...2
        {
            doors.append(SKSpriteNode(imageNamed: "closedDoor"))
            if self.size.width > 667.0 {xOffset = Int((self.size.width - 667)/2)}
            doors[i].position = CGPoint(x:Int(Int(self.size.width)/5 + xOffset) + i * 200, y:Int(self.size.height/(8/3)))
            doors[i].setScale(0.9)
            addChild(doors[i])
        }
        
        doorPrizes.append(SKSpriteNode(imageNamed:"goat"))
        doorPrizes[0].name = "goat"
        doorPrizes.append(SKSpriteNode(imageNamed:"redCar"))
        doorPrizes[1].name = "redCar"
        doorPrizes.append(SKSpriteNode(imageNamed:"money"))
        doorPrizes[2].name = "money"
        doorPrizes.shuffle()
    }
    
    func activated(_ index: Int)
    {
        doors[index].removeFromParent()
        doorPrizes[index].setScale(0.1)
        doorPrizes[index].position = CGPoint(x:Int(Int(self.size.width)/5 + xOffset) + index * 200, y:Int(self.size.height/(8/3)))
        addChild(doorPrizes[index])
        doorPrizes[index].zPosition = 1
        
        if GameScene.isSoundOn == true
        {
            switch doorPrizes[index].name
            {
            case "goat":
                let goatSound = SKAction.playSoundFileNamed("goatSound",waitForCompletion:false)
                doorPrizes[index].run(goatSound)
            case "redCar":
                let carSound = SKAction.playSoundFileNamed("carHorn",waitForCompletion:false)
                doorPrizes[index].run(carSound)
            case "money":
                let moneySound = SKAction.playSoundFileNamed("chaChing",waitForCompletion:false)
                doorPrizes[index].run(moneySound)
            default:
                print("something went wrong")
            }
        }
        
        doorPrizes[index].run(SKAction.sequence([SKAction.scale(to: 0.5, duration: 0.5), SKAction.wait(forDuration: 0.5), SKAction.scale(to: 0.05, duration: 0.5)]))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.75),
            SKAction.run() { [weak self] in
                
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameOver(size: self.size)
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            if doorPressed == 0
            {
                for door in doors
                {
                    let index = doors.firstIndex(of: door)!
                    let location = touch.location(in: self)
                    if door.contains(location)
                    {activated(index)}
                    doorPressed += 1
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
