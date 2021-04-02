//
//  Results.swift
//  Jeopardy
//
//  Created by Becca Gottlieb on 11/3/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ResultScene: SKScene
{
    static var totalPoints : Int = 0
    
    init(size: CGSize, buttonIndex: Int, result: Int, cashValue: Int)
    {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "jeopardyBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2)
        background.zPosition = -1
        addChild(background)
        
        func whichResult()
        {
            let titleLabel = SKLabelNode(fontNamed: "Copperplate")
            titleLabel.fontSize = 80
            titleLabel.position = CGPoint(x:self.size.width/2, y: self.size.height - (self.size.height/3))
            var text : String = " "
            
            let pointLabel = SKLabelNode(fontNamed: "Copperplate")
            pointLabel.fontSize = 80
            pointLabel.position = CGPoint(x:self.size.width/2, y: self.size.height/3)
            
            if result == 1
            {
                let backgroundMusic = SKAudioNode(fileNamed: "rightAnswer")
                backgroundMusic.autoplayLooped = true
                if GameScene.isSoundOn == true {addChild(backgroundMusic)}
                
                text = "CORRECT"
                ResultScene.totalPoints = ResultScene.totalPoints + cashValue
                titleLabel.fontColor = SKColor.yellow
                
                pointLabel.text = ("$\(cashValue)")
                pointLabel.fontColor = SKColor.yellow
            }
                
            else
            {
                let backgroundMusic = SKAudioNode(fileNamed: "wrongAnswer")
                backgroundMusic.autoplayLooped = true
                if GameScene.isSoundOn == true {addChild(backgroundMusic)}
                
                text = "WRONG"
                ResultScene.totalPoints = ResultScene.totalPoints - cashValue
                titleLabel.fontColor = SKColor.red
                
                pointLabel.text = ("-$\(cashValue)")
                pointLabel.fontColor = SKColor.red
            }
            titleLabel.text = text
            addChild(titleLabel)
            addChild(pointLabel)
        }
        
        whichResult()
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                GameScene.gameSceneLaunched += 1
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
    }
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
