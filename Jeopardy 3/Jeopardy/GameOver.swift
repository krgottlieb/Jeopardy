//
//  GameOver.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 11/18/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameOver: SKScene
{
    var buttons : [SKSpriteNode] = []
    var buttonLabels : [SKLabelNode] = []
    
    override init(size: CGSize)
    {
        super.init(size:size)
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        let playAgainLabel = SKLabelNode(fontNamed: "Copperplate")
        playAgainLabel.text = "Do you want to play again?"
        playAgainLabel.position = CGPoint(x:Int(self.size.width/2), y:Int(self.size.height - (self.size.height/3)))
        playAgainLabel.fontSize = 45
        addChild(playAgainLabel)
        
        for i in 0...1
        {
            buttons.append(SKSpriteNode())
            buttons[i].color = SKColor.blue
            buttons[i].size = CGSize(width: 100, height: 70)
            buttons[i].position = CGPoint(x:Int(self.size.width/(5/2)) + i * 140, y: Int(self.size.height)/2)
            buttons[i].zPosition = 0
            
            buttonLabels.append(SKLabelNode())
            buttonLabels[i] = SKLabelNode(fontNamed: "Copperplate")
            if i == 0 {buttonLabels[i].text = "YES"}
            else {buttonLabels[i].text = "NO"}
            buttonLabels[i].fontSize = 35
            buttonLabels[i].position = CGPoint(x: buttons[i].frame.midX, y: buttons[i].frame.midY-10)
            buttonLabels[i].fontColor = SKColor.yellow
            buttonLabels[i].zPosition = 1
            
            self.addChild(buttons[i])
            self.addChild(buttonLabels[i])
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activated(_ index: Int)
    {
        if index == 0
        {
            GameScene.usedButtons = []
            GameScene.gameSceneLaunched = 0
            ResultScene.totalPoints = 0
            QuestionScene.engQArrayUsed = []
            QuestionScene.geoQArrayUsed = []
            QuestionScene.hisQArrayUsed = []
            QuestionScene.latinQArrayUsed = []
            QuestionScene.mathQArrayUsed = []
            
            let gameScene = GameScene(size: self.size)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(gameScene, transition: reveal)
        }
        else {exit(0)}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            for button in buttons
            {
                let index = buttons.firstIndex(of: button)!
                let location = touch.location(in: self)
                if button.contains(location)
                {activated(index)}
            }
        }
    }
}
