//
//  GameScene.swift
//  F.arrow
//
//  Created by Gabriel Rocco on 11/07/2018.
//  Copyright © 2018 GRDeveloper. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit


//Quantidade de colorBalls do jogador, será salvo
var colorBalls = 0
let colorBallLabel = SKLabelNode()
var adsBt = SKSpriteNode()
var window: UIWindow?
var productBuy = String()
var adsMustLoad = true
var gameRunning = false
let buyResize = SKSpriteNode(imageNamed: "buyResize")
let buyDeleter = SKSpriteNode(imageNamed: "buyDeleter")
let buyUpgrade = SKSpriteNode(imageNamed: "up1")
let deleterNumberLabel = SKLabelNode()
let resizeNumberLabel = SKLabelNode()
let ballLevelLabel = SKLabelNode()
let upgradeBallLabel = SKLabelNode()
var logoBool = true





struct PhysicsCategory {
    //Categorias físicas para diferenciar os corpos e poder criar regras para as interações
    static let ballCategory : UInt32 = 1
    static let obstacleCategory : UInt32 = 2
    static let deleterCategory : UInt32 = 4
      static let clockCategory : UInt32 = 8
     static let pipeCategory : UInt32 = 16
     static let gigaCategory : UInt32 = 32
       static let wallCategory : UInt32 = 64


}



class GameScene: SKScene, SKPhysicsContactDelegate, GADRewardBasedVideoAdDelegate,SKViewDelegate, GADInterstitialDelegate{
 
    
    
    func removeFromScene(){
        deleterNumberLabel.removeFromParent()
        deleterNumberLabel.removeFromParent()
        upgradeBallLabel.removeFromParent()
        ballLevelLabel.removeFromParent()
        buyResize.removeFromParent()
        buyDeleter.removeFromParent()
        buyUpgrade.removeFromParent()
    }


    func view(_ view: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {
        return true
    }


    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    

    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.mygamename"
  

    
    
    
    
    
    
    
    
    //Limita a tentativa de carregar novos anúncios a cada falha! Limitado em 3 falhas, depois disso nada mais é feito!
        var adTentativas = 0
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "cac-app-pub-8409835855520197/4437943235")
        adTentativas = 0
        backgroundMusic.run(SKAction.changeVolume(to: 1, duration: 0.5))
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        backgroundMusic.run(SKAction.changeVolume(to: 0, duration: 0))
    }
    


    

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
        if adTentativas != 3 {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "cac-app-pub-8409835855520197/4437943235")
            adTentativas += 1
        }
    }
    

    func loadAd(){
           if GADRewardBasedVideoAd.sharedInstance().isReady == true {
           }else{
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                        withAdUnitID: "cac-app-pub-8409835855520197/4437943235")
        }
      
    }
    
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        colorBalls += score
        UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
        UserDefaults.standard.synchronize()
        presentScene()
    }
    
     deinit{print("deinit OK")}
    
    func presentScene(){
        //vortaa
        logoBool = false
        scene?.removeAllActions()
        scene?.removeAllChildren()
        removeFromScene()
        
        for node in (scene?.children)! {
            node.removeAllActions()
            node.removeFromParent()
        }
        let sceneGo = GameScene(fileNamed: "GameScene")!
        sceneGo.scaleMode = .resizeFill
        self.view?.presentScene(sceneGo)
   
    }

    
    
//SKPhysicsContactDelegate
    
    //Serve para adicionar os anúncios caso não tenha sido comprado

    func removeAd(){
        UserDefaults.standard.set(true, forKey: "adsRemovedSaved")
        UserDefaults.standard.synchronize()
           adsMustLoad = false
          adsBt.alpha = 0.3
    }
    
  
    
    

   
    
    
    

    

    


  
    func receiveColorBalls(){
        buyResize.alpha = 1
        buyDeleter.alpha = 1
        buyUpgrade.alpha = 1
        deleterNumberLabel.alpha = 1
        upgradeBallLabel.alpha = 1
        ballLevelLabel.alpha = 1
        resizeNumberLabel.alpha = 1
        colorBalls += 40000
        UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
        UserDefaults.standard.synchronize()
         colorBallLabel.text = "\(colorBalls)"
    }
    
    
    
    

    
    
    
     var currentFPS = CGFloat()
    
    var heliceLastPosition = CGFloat()
    
    //Vai ser salvo depois com NSUserDefaults
    //Controla a quantidade de cada poder:
    var deleterNumber = 3
    var resizeNumber = 0
    var ballValue = 2000
    
    var continueAd = SKSpriteNode(imageNamed: "continueAd")
    
    var repeatPrevent = 0
    var lastUpdateTime: TimeInterval = 0
    
    let colorBallNode = SKSpriteNode(imageNamed: "colors")
    var backgroundMusic = SKAudioNode()
    let buyColorBall = SKSpriteNode(imageNamed: "buyColorBalls")
   
    var ballLevel = 1
    
    var continueLabel = SKLabelNode()
var restartLabel = SKLabelNode()


    //Quantidade de colorBalls antes de iniciar o jogo, será utilizado para calculador os colorNodes ganhos na partida
    var lastColorBalls = 0
    
    
//Timer que conta o tempo de jogo restante
    var timerCount = TimeInterval()
    var timerLabel = SKLabelNode()
//Variável random que da um tempo a mais se o relógio for pego durante o jogo
var timerMore = TimeInterval()

    
    var canScore = false
    
    
    //Indica a quantidade de clocks gerados para restricoes da quantidade de geração num jogo e no momento de geração do colorBall
    var clockGenerated = 0
    
    
    //Este é o Highscore, é salvo:
var bestScore = 0
    var bestScoreLabel = SKLabelNode()

    
    //Esta variável calcula a posição da bolinha a cada 5s na função gameOver, caso a nova posição seja menor que a anterior somada a 10% da view é porque o caminho foi fechado e o jogo acaba....
var positionGameOver = CGFloat()
    //Detecta se o jogo acabou:
    var isGameOver = false
    var pinnedOver = false
    
    //Variáveis que liberam a repetição infinita das funções de geração.
    var f1 = false //gera bolinhas caindo
    var f2 = false //bolinhas fixas
    var f3 = false//bolinhas que crescem
    var f4 = false//retangulos!
    
    var bitelaAway = false
    //Salva o score anterior a cada parte do jogo para assim calcular a cada instante um "deltaScore" e mudar a parte.
var lastScore = 0
    var grdevNode = SKSpriteNode(imageNamed: "grdev")
    //Multiplicadores e divisores que vão dificultar o jogo conforme o jogador avança:
var lvlMultiplier = 1.0
    var lvlDivisior = 1.0
    var pinnedDivisor = 1.0
    var obstacle2Multiplier = 1.0
    
    
    
    //Para animação quando o jogador obtiver um novo highscore
    var highscored = false //Caso tenha obtido um highscore
    var highscoredAnimation = false //Para controlar a animação
    
    //é ativado na última fase para estabelecer um relógio que da um tempo de 60s
    var newClock = false
    
    
    //Nível dos poderes:
    var scaleLevel = 12.0 //Nível do poder que reduz a bolinha! Será salvo!!!!
    
    
    //Poderes utilizados: (somente 1 utilizacao de cada por jogo)
    var resizeUsed = false //Resize power, diminui o tamanho da bolinha
    var removerUsed = false //Indica se o poder de remoção foi usado
    var removerActive = false //Indica se o poder de remoção está ativado para ligar a remoção física
    
    
    //Controla as fases do jogo
      var m0 = false
    var m1 = false
    var m2 = false
    var m3 = false
    var m4 = false
    var m5 = false
     var m6 = false
    var m7 = false
    var m8 = false
    var m9 = false
    var m10 = false
    var obst2conf2 = false
var pinnedRandom = Int()
    
    //Controla o score e outras coisas relacionadas a ela
    var score = 0
    var initial = 0
    var scoreLabel = SKLabelNode()
    var scored = false
    
    //Muro direito e esquerdo que impede as bolinhas e o jogador de sair da cena
     let wallRight  = SKSpriteNode(imageNamed: "wall")
 let wallLeft = SKSpriteNode(imageNamed: "wall")
    //Fica uma view de distância do jogador e quando qualquer obstáculo entra em contato com o deleter ele é removido, foi implementado para evitar problemas de FPS, renderização, etc já que facilmente pode-se ultrapassar 3000 nodes num jogo mais longo
     var deleter = SKSpriteNode(imageNamed: "wall")
    
    let colorBlack = SKSpriteNode(imageNamed: "black")
    //Título e botões dos menus
      var title = SKSpriteNode()
     let rankBt = SKSpriteNode(imageNamed: "rankBt")
      let buyBt = SKSpriteNode(imageNamed: "buyBt")
     let colorBt = SKSpriteNode(imageNamed: "powerBt")
var conferidorChoose = 0
    //Botões dos poderes
     let resizeBt = SKSpriteNode(imageNamed: "resizeBt")
    let removerBt = SKSpriteNode(imageNamed: "removerBt")
    var removerEnabled = false
    
    //O jogador:
    let ball = SKSpriteNode(imageNamed: "ball")
    //Chão com grama no início do jogo
     let ground = SKSpriteNode(imageNamed: "ground")

    
//Indica se o jogo está rodando
var gameRunning = false
    //Textos da tela de início dizendo a direção que a bolinha se move no clique
    var leftText = SKSpriteNode(imageNamed: "leftText")
     var rightText = SKSpriteNode(imageNamed: "rightText")
    //Câmera do jogo:
     var myCamera = SKCameraNode()
    //Ações utilizadas no Start() e no gameOver() para remover ou adicionar elementos.
  
     


    //textura dos obstaculos
      let whiteBall = SKTexture(imageNamed: "whiteBall")
     let blackBall = SKTexture(imageNamed: "blackBall")
    //Velocidade de geração
    var generateVelocity = TimeInterval() //Bolinhas brancas que caem --> generate()
     var retanguloTime = TimeInterval() //Bolinhas brancas que caem --> generate()
    var pinnedDuration = TimeInterval() //Bolinhas fixas --> generatePinned
    var barreiraCalled = false //Indica se a função barreira foi executada
    var massObstacle = 3.0 //Massa da bolinha que cai --> generate()
    var scale = 1.0 //escala da bolinha pinned
    var nn = 16
    var nn2 = 16
    var nnn = 15
  var canStart = false

    //Função quando começa o jogo
    func start(){
      
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            nn2 = 22
            nn = 22
            nnn = 19
        }else{
            nn2 = 16
            nn = 16
            nnn = 15
        }

 if currentFPS >= 1 {
            let FPSNow = currentFPS
  if FPSNow >= 1 {
                scene?.physicsWorld.speed = 0.99
              gameRunning = true
        

        ball.run(SKAction.wait(forDuration: 0.5)) {
            self.canScore = true
              self.initial = Int(self.ball.position.y)
        }
        
        
   deleterNumberLabel.removeFromParent()
        upgradeBallLabel.removeFromParent()
    resizeNumberLabel.removeFromParent()
        ballLevelLabel.removeFromParent()
        
        
   deleterNumberLabel.alpha =  1
  resizeNumberLabel.alpha = 1
        

        if (view?.bounds.height)! != 812.0{
          
                deleterNumberLabel.position = CGPoint(x: 0+removerBt.frame.width, y: (view?.frame.height)!*0.45-removerBt.frame.height-deleterNumberLabel.frame.height)
                
                resizeNumberLabel.position = CGPoint(x: 0-resizeBt.frame.width, y: (view?.frame.height)!*0.45-removerBt.frame.height-deleterNumberLabel.frame.height)
                
       
         
            
        }else{
            //iphonex
            deleterNumberLabel.position = CGPoint(x: 0+removerBt.frame.width, y: (view?.frame.height)!*0.45-removerBt.frame.height-deleterNumberLabel.frame.height)
            
            resizeNumberLabel.position = CGPoint(x: 0-resizeBt.frame.width, y: (view?.frame.height)!*0.45-removerBt.frame.height-deleterNumberLabel.frame.height)
                }

        if UIDevice.current.userInterfaceIdiom == .pad {
            resizeBt.setScale(1)
            removerBt.setScale(1)
            resizeBt.position = CGPoint(x: 0-resizeBt.frame.width, y: (view?.frame.height)!*0.515-resizeBt.frame.height)
            removerBt.position = CGPoint(x: 0+removerBt.frame.width, y: (view?.frame.height)!*0.515-removerBt.frame.height)
            deleterNumberLabel.fontSize = 45
             resizeNumberLabel.fontSize = 45
            deleterNumberLabel.position = CGPoint(x: 0+removerBt.frame.width, y: (view?.frame.height)!*0.465-removerBt.frame.height-deleterNumberLabel.frame.height)
            
            resizeNumberLabel.position = CGPoint(x: 0-resizeBt.frame.width, y: (view?.frame.height)!*0.465-removerBt.frame.height-deleterNumberLabel.frame.height)
            
    
  
        }
                
                
                myCamera.addChild(deleterNumberLabel)
                myCamera.addChild(resizeNumberLabel)
        
        buyColorBall.position = CGPoint(x: -(view?.frame.width)!*1.5, y: 0)
        buyResize.position = CGPoint(x: -(view?.frame.width)!*1.5, y: 0)
        buyDeleter.position = CGPoint(x: -(view?.frame.width)!*1.5, y: 0)
      buyUpgrade.position = CGPoint(x: -(view?.frame.width)!*1.5, y: 0)
        adsBt.position = CGPoint(x: -(view?.frame.width)!*1.5, y: 0)
          deleterNumberLabel.text = "\(deleterNumber)"
        resizeNumberLabel.text = "\(resizeNumber)"
        self.removeAllActions()
        title.removeAllActions()
        buyDeleter.removeAllActions()
        buyColorBall.removeAllActions()
        buyResize.removeAllActions()
        //Nenhum poder utilizado:
        resizeUsed = false
        removerUsed = false
        removerActive = false
        
        //Variáveis auxiliares:
        lastScore = 0
        clockGenerated = 0
        isGameOver = false
        positionGameOver = ball.position.y-(view?.frame.height)!
        newClock = false
        retanguloTime = 0.22*(1.025-(Double(ballLevel)*0.02))
 




   

       


        if Int(arc4random_uniform(2)) == 0{
            repeatPrevent = 1
            self.timerCount = TimeInterval(56+(self.ballLevel-1)*1)
            self.timerLabel.text = "\(Int(self.timerCount))"
            //Funções auxiliares
            self.gameOver()
            self.gameOver2()
            self.elements()
            self.timerCountFunction()
             self.conferidorChoose = 1
        self.conferidor()
        }else{
            repeatPrevent = 1
            self.timerCount = TimeInterval(40+(self.ballLevel-1)*1)
            if UIDevice.current.userInterfaceIdiom == .pad {
               self.timerCount += 2
            }
             self.timerLabel.text = "\(Int(self.timerCount))"
            //Funções auxiliares
            self.gameOver()
            self.gameOver2()
            self.elements()
            self.timerCountFunction()
             self.conferidorChoose = 2
            self.conferidor2()
        }

        //Remove os elementos do menu inicial:
        rightText.run(SKAction.fadeOut(withDuration: 0.2))
        rankBt.run(SKAction.fadeOut(withDuration: 0.2))
        title.run(SKAction.fadeOut(withDuration: 0.2))
        bestScoreLabel.run(SKAction.fadeOut(withDuration: 0.2))
        adsBt.run(SKAction.fadeOut(withDuration: 0.2))
        colorBallNode.run(SKAction.fadeOut(withDuration: 0.2))
        colorBallLabel.run(SKAction.fadeOut(withDuration: 0.2))
         buyResize.run(SKAction.fadeOut(withDuration: 0.2))
        buyDeleter.run(SKAction.fadeOut(withDuration: 0.2))
        buyColorBall.run(SKAction.fadeOut(withDuration: 0.2))
        buyUpgrade.run(SKAction.fadeOut(withDuration: 0.2))
        //botoes dos poderes aparecem/ e score+tempo
        if resizeNumber > 0 {
        resizeBt.run(SKAction.fadeIn(withDuration: 0.5))
        }else {
              resizeBt.run(SKAction.fadeAlpha(to: 0.3, duration: 0.5))
        }
        
        if deleterNumber > 0 {
              removerBt.run(SKAction.fadeIn(withDuration: 0.5))
        }else {
            removerBt.run(SKAction.fadeAlpha(to: 0.3, duration: 0.5))
        }
    
        
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.5))
        timerLabel.run(SKAction.fadeIn(withDuration: 0.5))
    
        
        
        leftText.run(SKAction.fadeOut(withDuration: 0.2), completion:
            {
               buyDeleter.removeFromParent()
colorBallLabel.removeFromParent()
                self.colorBallNode.removeFromParent()
                adsBt.removeFromParent()
                self.rankBt.removeFromParent()
                self.title.removeFromParent()
                upgradeBallLabel.removeFromParent()
                self.leftText.removeFromParent()
                self.rightText.removeFromParent()
buyResize.removeFromParent()
                self.buyColorBall.removeFromParent()
                buyUpgrade.removeFromParent()
        })
    }
    }}
    
    
    
    
    

    
    
    
    
    
    
    
    

    

    
    

    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //gera os relogios e os coloca na tela, somente 1 por rodada, talvez
    func clockGenerate(){
         let clockNode = SKSpriteNode(imageNamed: "clock")

        clockNode.size = CGSize(width: (view?.frame.width)!*0.12, height: (view?.frame.width)!*0.12)
        if  UIDevice.current.userInterfaceIdiom == .pad {
            clockNode.setScale(0.85)
        }
        clockNode.physicsBody = SKPhysicsBody(circleOfRadius: clockNode.frame.width/2)
        clockNode.zPosition = 2
        clockNode.physicsBody?.categoryBitMask = PhysicsCategory.clockCategory
     clockNode.physicsBody?.contactTestBitMask = PhysicsCategory.ballCategory | PhysicsCategory.obstacleCategory | PhysicsCategory.gigaCategory | PhysicsCategory.pipeCategory
        var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
        if Int(arc4random_uniform(2)) == 0 {
            random = -(random)+clockNode.frame.width
        }else{
              random -= clockNode.frame.width
        }
        clockNode.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!*0.5+ball.position.y)
        clockNode.physicsBody?.isDynamic = false
        clockNode.physicsBody?.allowsRotation = false
        clockNode.physicsBody?.pinned = true
        
        clockNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.8), SKAction.scale(to: 1.0, duration: 0.8)])))
addChild(clockNode)
    }
    
    


    
    
    
    
    
    
    func conferidor2() {
        var deltaScore = score - lastScore
       
        if m0 == false {
            if deltaScore >= 0 {
                pinnedRandom = Int(arc4random_uniform(2))
                  deltaScore = -1
                m9 = false
                lastScore = score
                self.generateVelocity = 0.115
                self.massObstacle = 3.0
                self.pinnedDuration = 0.11*(1.02-(Double(self.ballLevel)*0.02))
                 if UIDevice.current.userInterfaceIdiom == .pad {
                      self.pinnedDuration = 0.07*(1.02-(Double(self.ballLevel)*0.02))
                }
                self.heliceGenerate()
                m0 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
                
            }
        }
        
        
        
       
        
        if m0 == true && m1 == false   {
            if deltaScore >= 2 {
                  deltaScore = -1
                lastScore = score
                pipeGenerate()
                 m1 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
return
            }
        }
        
        
        
        
        
        if m0 == true && m1 == true && m2 == false {
        
            
            
            if deltaScore >= nnn { //15
                  deltaScore = -1
                //muda o lastscore
                lastScore = score
                f3 = true
                
                generateVelocity = 0.2/lvlDivisior
                if generateVelocity >= 0.195 {
                    generateVelocity = 0.195
                }
                massObstacle = 0.03
              bolinhaBitela()
  m2 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
            }
        }
        
        
        
        
        
        
        if m0 == true && m1 == true && m2 == true && m3 == false {
            if deltaScore >= 15 {
                  deltaScore = -1
                lastScore = score
                f3 = false
                pinnedOver = true
                    f4 = true
                     retanguloTime = 0.07*(1.025-(Double(ballLevel)*0.02))
                    generateRectangle()
                m3 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
            }
        }
        
        
        
        
        
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == false {
            if  deltaScore >= 8{
                  deltaScore = -1
                lastScore = score
                barreiraCalled = false
                barreira()
                m4 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
            }
        }

        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == false {
            if deltaScore >= 16 {
                  deltaScore = -1
                //muda o lastscore
                lastScore = score
                f1 = true
                massObstacle = 0.5
                 retanguloTime = 0.07*(1.025-(Double(ballLevel)*0.02))
                if pinnedRandom == 0 {
                generateVelocity = 0.39/lvlDivisior
                if generateVelocity < 0.37 {
                    generateVelocity = 0.37
                }
                }else{
                    generateVelocity = 0.41/lvlDivisior
                    if generateVelocity < 0.39 {
                        generateVelocity = 0.39
                    }
                }
                massObstacle = 3.0 * lvlMultiplier
                generate()
                 m5 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
            }
        }
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == false {
            if deltaScore >= 16{
                deltaScore = -1
                //muda o lastscore
                lastScore = score
                pinnedOver = false
              f4 = false
                generateVelocity = 0.37/lvlDivisior
                m6 = true
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
               return
            }
        }
        
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == false {
            if deltaScore >= 8{
                deltaScore = -1
                //muda o lastscore
                lastScore = score
                m7 = true
            obst2conf2 = true
                obstacle2()
                barreiraCalled = true
                generateVelocity = 0.13/lvlDivisior
                if generateVelocity < 0.061 {
                    generateVelocity = 0.07
                }
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return

            }
        }
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == true && m8 == false {
            if deltaScore >= 1 {
                deltaScore = -1
                  m8 = true
                lastScore = score
                   f1 = false
                 barreira()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor2()
                })
                return
                
            }
        }
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == true && m8 == true && m9 == false {
            
         
            if deltaScore >= nn2{
                deltaScore = -1
                 obst2conf2 = false
                ball.removeAllActions()
                 lastScore = score
                lvlMultiplier += 0.1
                lvlDivisior += 0.13
                //  pinnedDivisor += 0.03
                obstacle2Multiplier -= 0.09
                if obstacle2Multiplier < 0.699 {
                    obstacle2Multiplier = 0.7
                }
         
                if repeatPrevent < 2 {
                if Int(arc4random_uniform(2)) == 0{
                    repeatPrevent = 1
                    conferidorChoose = 1
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                }else{
                    repeatPrevent = 2
                    conferidorChoose = 2
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor2()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                    }
                }else{
                    repeatPrevent = 1
                    conferidorChoose = 1
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                }
                    
                }
            
            
        }

        
        
        
        
        
        
        if conferidorChoose == 2{
        ball.run(SKAction.wait(forDuration: 0.1), completion: {
            self.conferidor2()
        })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Esta maravilhosa função, meio arcaica na verdade, mas muito bacana pois foi o maior problema do jogo que precisei resolver e tive esta ideia que funcionou perfeitamente...esta função roda repetidamente a cada 0.1s (pode parecer pouco mas isso da 10x por segundo, a func update roda 60x...e é do próprio spritekit).
    //Ela controla toda a sequencia do jogo calculando o deltaScore, ou seja, a variação no score do jogador, a cada variação de n ou n+1 (para garantir que seja executada) pontos mudará a fase automaticamente. Bem melhor que controlar de forma completamente desordenada nas funções de geração....
    //Além disso, esta função serve infinitamente, ou seja, vai executar esta sequência até o final e depois recomeçar ajustando as variáveis da dificuldade...Não sendo necessário um código imenso e bagunçado pra ficar repetindo tudo.
    func conferidor() {
let deltaScore = score - lastScore

        
        if m0 == false {
             if deltaScore >= 0  {
                m0 = true
                m9 = false
                 pinnedRandom = Int(arc4random_uniform(2))
            lastScore = score
            self.generateVelocity = 0.115
                  if UIDevice.current.userInterfaceIdiom == .pad {
                      self.generateVelocity = 0.1
                }
            self.massObstacle = 3.0
            self.pinnedDuration = 0.11*(1.02-(Double(self.ballLevel)*0.02))
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.pinnedDuration = 0.07*(1.02-(Double(self.ballLevel)*0.02))
                }
            self.f1 = true
            self.generate()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        if m0 == true && m1 == false   {
            if deltaScore >= 12 {
            //p nao repetir isso
            m1 = true
            //muda o lastscore
            lastScore = score
            //libera a função pinned
            f2 = true
                //A função gameOver pode atuar aqui!
                pinnedOver = true

            //Inicia a função pinned
            generatePinned()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
          if m0 == true && m1 == true && m2 == false {
            if deltaScore >= 2 {
                m1 = true
                //muda o lastscore
                lastScore = score
                
            m2 = true
            //para a função generate
                generateVelocity = 0.4/lvlDivisior
                if generateVelocity < 0.35{
                    generateVelocity = 0.35
                }
                if score < 110 {
            f1 = false
                }
           
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
            }
        
        
     
        if m0 == true &&  m1 == true && m2 == true && m3 == false {
            if deltaScore >= 18 {
                m1 = true
                 lastScore = score
                m3 = true
                pinnedRandom = 1
                //a massa das bolinhas que caem fica mais baixa para nao ter taaanto impacto no jogador
             massObstacle = 1.8 * lvlMultiplier
                //O tamanho dos pinned aumenta
                scale = 1.3
                
                if score < 110 {
                //generate bolinhas volta a funcionar agora
                f1 = true
                //chama a funcao das bolinhas que caem
                generate()
                }
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        
        
        if  m0 == true && m1 == true && m2 == true && m3 == true && m4 == false {
            if deltaScore >= 45 {
                //muda o lastscore
                lastScore = score
                m4 = true
                //desativa o pinned e as bolinhas que caem
              f1 = false
                f2 = false
                pinnedOver = false
            //ativa a barreira que sera executada 2x...uma por aqui e a segunda la
                //barreira called certifica-se que a barreira sera exacutada 2x, e apenas 2x.
                barreiraCalled = false
                barreira()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        

        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == false {
            if deltaScore >= 4 {
                //muda o lastscore
                lastScore = score
                m5 = true
                obstacle2()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == false {
            if deltaScore >= 6 {
                
                //Adiciona um relógio aqui caso nenhum tenha sido adicionado nesta rodada ainda
                /*
                if clockGenerated == 0 && timerCount <= 26 {
                    clockGenerated = 1
                    clockGenerate()
                }
 */
                //muda o lastscore
                lastScore = score
                
                m6 = true
                //aciona as bolinhas que caem de novo na cor preta e com massa bem pequena. O player tem massa 1, aqui será 0.7 pois ficarao na saida
                f1 = true
                generateVelocity = 0.1/lvlDivisior
                if generateVelocity < 0.061 {
                    generateVelocity = 0.061
                }
                massObstacle = 0.1
                generate()
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == false {
            if deltaScore >= 15 {
                //muda o lastscore
                lastScore = score
                m7 = true
                //aciona as bolinhas bitela hehehe e desativa as normais:
                //NÃO CHAMAR F1 e F3 JUNTO POIS USAM O MESMO COMANDO
                f1 = false
                
                generateVelocity = 0.23/lvlDivisior
                if generateVelocity >= 0.205 {
                    generateVelocity = 0.205
                }
                massObstacle = 0.03
                
                f3 = true
                bolinhaBitela()
                
        
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == true && m8 == false {
            if deltaScore >= 15{
                f3 = false
                bitelaAway = true
                 pinnedOver = false
    pinnedOver = false

                //muda o lastscore
                lastScore = score
                m8 = true

                ball.run(SKAction.wait(forDuration: 0.55)) {
                    self.barreira()
                    self.obstacle2()
                   
                }
                ball.run(SKAction.wait(forDuration: 0.4), completion: {
                    self.conferidor()
                })
                return
            }
        }
        
        
        if m0 == true && m1 == true && m2 == true && m3 == true && m4 == true && m5 == true && m6 == true && m7 == true && m8 == true && m9 == false {
         
            if deltaScore >= nn {
                
           ball.removeAllActions()
                lvlMultiplier += 0.1
                lvlDivisior += 0.13
              //  pinnedDivisor += 0.03
                obstacle2Multiplier -= 0.09
                if obstacle2Multiplier < 0.699 {
                    obstacle2Multiplier = 0.7
                }
                lastScore = score
                m9 = true
                bitelaAway = false
                
                 if repeatPrevent < 2 {
                if Int(arc4random_uniform(2)) == 0{
                    repeatPrevent = 2
                    conferidorChoose = 1
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                }else{
                    repeatPrevent = 1
                     conferidorChoose = 2
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor2()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                }
                    
                 }else{
                    repeatPrevent = 1
                    conferidorChoose = 2
                    newClock = true
                    clockGenerate()
                    clockGenerated = 0
                    conferidor2()
                    gameOver()
                    gameOver2()
                    elements()
                    timerCountFunction()
                    m9 = true
                    m0 = false
                    m1 = false
                    m2 = false
                    m3 = false
                    m4 = false
                    m5 = false
                    m6 = false
                    m7 = false
                    m8 = false
                    
                    
                }
                
                lastScore = score
      
             

            }
        }

        if conferidorChoose == 1 {
        ball.run(SKAction.wait(forDuration: 0.1), completion: {
            self.conferidor()
        })
        }
    }
    
    
    
    
    
    
    
    
    
    //Função para facilitar o random:
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    //Array de cores que vão mudando:
    let colorsBackArray = [UIColor(red:0.00, green:1.00, blue:1.00, alpha:1.0),UIColor(red:0.00, green:0.72, blue:1.00, alpha:1.0),UIColor(red:1.00, green:0.31, blue:1.00, alpha:1.0),UIColor(red:0.87, green:0.31, blue:1.00, alpha:1.0), UIColor(red:0.76, green:0.31, blue:1.00, alpha:1.0),UIColor(red:0.30, green:0.86, blue:0.39, alpha:1.0),UIColor(red:0.41, green:0.84, blue:1.00, alpha:1.0),UIColor(red:0.28, green:0.54, blue:1.00, alpha:1.0),UIColor(red:0.65, green:0.00, blue:1.00, alpha:1.0),UIColor(red:0.52, green:1.00, blue:0.36, alpha:1.0),UIColor(red:0.56, green:0.21, blue:0.75, alpha:1.0),UIColor(red:0.46, green:0.24, blue:1.00, alpha:1.0), UIColor(red:0.00, green:1.00, blue:0.85, alpha:1.0), UIColor(red:0.30, green:1.00, blue:0.55, alpha:1.0),UIColor(red:1.00, green:0.65, blue:0.15, alpha:1.0)]
    
    
    
    
    
    //Esta função é responsável por mudar as cores a cada pontuação de 10 e também por executar a animação do highscore
    func elements(){
        if gameRunning == true {
        if score > bestScore && highscoredAnimation == false && Int(UserDefaults.standard.integer(forKey: "bestscoreSaved")) > 0 {
            highscored = true
        }
        if highscored == true {
            self.highscoredAnimation = true
            var coresHighscore = [UIColor()]
            scoreLabel.run(SKAction.scale(to: 1.3, duration: 0.1))
            ball.run(SKAction.playSoundFileNamed("highscored", waitForCompletion: false))
            for _ in 1...10{
                coresHighscore.append(colorsBackArray[Int(arc4random_uniform(UInt32(colorsBackArray.count)))])
            }
            scene?.run(SKAction.sequence([SKAction.colorize(with: coresHighscore[0], colorBlendFactor: 1, duration: 0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[1], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[3], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[4], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[5], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[6], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[7], colorBlendFactor: 1, duration: 0.0), SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[8], colorBlendFactor: 1, duration: 0.0),SKAction.wait(forDuration: 0.1),SKAction.colorize(with: coresHighscore[9], colorBlendFactor: 1, duration: 0.0)]), completion:
                {
                       self.scoreLabel.run(SKAction.scale(to: 1, duration: 0.8))
                    self.highscored = false
                    self.elements()
        })
           
            
            

        }
        
        if highscored == false {
        let x = score.quotientAndRemainder(dividingBy: 10)
        let randomColor = Int(arc4random_uniform(UInt32(colorsBackArray.count)))
        
        if x.remainder == 0 && scored == false && score > 9 {
            scored = true
            scene?.run(SKAction.colorize(with: colorsBackArray[randomColor], colorBlendFactor: 1, duration: 1))
        }else if x.remainder != 0 && scored == true {
            scored = false
        }
        }
        ball.run(SKAction.wait(forDuration: 0.1), completion:
            {if self.highscored == true {
            }else{
                self.elements()
                }
              
        })
        
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Essa função cria bolinhas que crescem, ficando de tamanhos variados e random, deve ser executada no conferidor.
    func bolinhaBitela(){
        //Umas bolinha giga aqui porra hasuhsauhuas
       let obstacle = SKSpriteNode()
        //vamo ve se vai se preta ou branca
        var randBitela = Int(arc4random_uniform(2))
        if randBitela == 0 {
            obstacle.texture = whiteBall
        }else if randBitela == 1{
            obstacle.texture = blackBall
        }
        
        
        
        obstacle.size = CGSize(width: (view?.frame.width)!*0.06, height: (view?.frame.width)!*0.06)
        if  UIDevice.current.userInterfaceIdiom == .pad {
            obstacle.setScale(0.6)
        }
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.width/2)
        obstacle.physicsBody?.affectedByGravity = false
 
        
        var scaleBitela = 0.0
        randBitela = Int(arc4random_uniform(3))
        if randBitela == 0 {
           scaleBitela = 4
        }else if randBitela == 1{
           scaleBitela = 5
        }else if randBitela == 2{
            scaleBitela = 6
        }
        
      
        obstacle.physicsBody?.friction = 0
        obstacle.physicsBody?.restitution = 0
        obstacle.physicsBody?.mass = CGFloat(massObstacle)
        obstacle.zPosition = 2
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.gigaCategory
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.pipeCategory
        
        var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
        if Int(arc4random_uniform(2)) == 0 {
            random = -(random)
        }
        obstacle.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!+ball.position.y)
        obstacle.physicsBody?.velocity = CGVector(dx: 0, dy: -1100)
        addChild(obstacle)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
          //  obstacle.setScale(0.6)
            obstacle.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.scale(to: CGFloat(scaleBitela*0.6), duration: 0.4)]))
        }else{
            obstacle.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.scale(to: CGFloat(scaleBitela), duration: 0.4)]))
        }
        
        
        ball.run(SKAction.wait(forDuration: generateVelocity)) {
            if self.gameRunning == true && self.f3 == true{
               self.bolinhaBitela()
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Função que simula o timer. HEHEHE FIZ SOZINHO!!! Devido a problemas que a implementação de um timer pode trazer, fiz uma função utilizando SKAction para alternativa do timer.
    //TIMER AQUI
    func timerCountFunction(){
        if gameRunning == true{
        if timerCount > 0 {
            if timerCount <= 5 {
                timerLabel.fontColor = UIColor.red
            }else{
                  timerLabel.fontColor = UIColor.white
            }
            let timer = SKAction.wait(forDuration: 1)
            ball.run(timer, completion: {
                self.timerCount -= 1
                self.timerLabel.text = "\(Int(self.timerCount))"
                self.timerCountFunction()
           
            })
        }else if timerCount == 0{
            self.gameOver()
            }
            
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    //Cria os pipes (como eu chamei), deve ser chamada no conferidor.
    func obstacle2(){
  
        for i in 1...10{
      let randomPosition = random(min: -100, max: 100)
        let pipe1 = SKSpriteNode(imageNamed: "pipe")
        let pipe2 = SKSpriteNode(imageNamed: "pipe")

        
        pipe1.size = CGSize(width: (view?.frame.width)!/0.5, height: (view?.frame.height)!*0.01)
          pipe2.size = CGSize(width: (view?.frame.width)!/0.5, height: (view?.frame.height)!*0.01)
        
            let xx = 0.08*CGFloat(obstacle2Multiplier)
            if obst2conf2 == false {
                pipe1.position = CGPoint(x: -(view?.frame.width)!-((view?.frame.width)!*xx)+randomPosition, y: ((view?.frame.height)!*0.85+ball.position.y)+(view?.frame.height)!*0.15*CGFloat(i))
                pipe2.position = CGPoint(x: (view?.frame.width)!+((view?.frame.width)!*xx)+randomPosition, y: ((view?.frame.height)!*0.85+ball.position.y)+(view?.frame.height)!*0.15*CGFloat(i))
            }else{
                pipe1.position = CGPoint(x: -(view?.frame.width)!-((view?.frame.width)!*xx)+randomPosition, y: ((view?.frame.height)!*0.4+ball.position.y)+(view?.frame.height)!*0.15*CGFloat(i))
                pipe2.position = CGPoint(x: (view?.frame.width)!+((view?.frame.width)!*xx)+randomPosition, y: ((view?.frame.height)!*0.4+ball.position.y)+(view?.frame.height)!*0.15*CGFloat(i))
            }
        
           
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
          pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2.size)
            pipe1.physicsBody?.categoryBitMask = PhysicsCategory.pipeCategory
   pipe1.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.gigaCategory | PhysicsCategory.ballCategory
            pipe2.physicsBody?.categoryBitMask = PhysicsCategory.pipeCategory
  pipe2.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.gigaCategory | PhysicsCategory.ballCategory
        pipe1.physicsBody?.isDynamic = false
        pipe2.physicsBody?.isDynamic = false
        
addChild(pipe1)
        addChild(pipe2)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func heliceGenerate(){
        
        for i in 1...7{
            let pipe1 = SKSpriteNode(imageNamed: "pipe")
             let pipe2 = SKSpriteNode(imageNamed: "pipeWhite")
            if Int(arc4random_uniform(2)) == 0 {
                pipe1.texture = SKTexture(imageNamed: "pipeWhite")
                 pipe2.texture = SKTexture(imageNamed: "pipe")
            }
            
            pipe1.size = CGSize(width: (view?.frame.width)!*0.15, height: (view?.frame.height)!*0.01)
            
             if UIDevice.current.userInterfaceIdiom == .pad {
                if score > 10 {
                pipe1.position = CGPoint(x:0-(view?.frame.width)!/2+pipe1.frame.width*0.7+CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*1.25+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
                }else{
                     pipe1.position = CGPoint(x:0-(view?.frame.width)!/2+pipe1.frame.width*0.7+CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*0.5+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
                }
             }else{
                pipe1.position = CGPoint(x:0-(view?.frame.width)!/2+pipe1.frame.width*0.7+CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*0.5+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
            }
            
            pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
            pipe1.physicsBody?.mass = 1
            pipe1.physicsBody?.angularVelocity = -10000
            pipe1.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
            pipe1.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory
            pipe1.physicsBody?.affectedByGravity = false
            pipe1.physicsBody?.pinned = true

            pipe2.size = CGSize(width: (view?.frame.width)!*0.15, height: (view?.frame.height)!*0.01)
            if UIDevice.current.userInterfaceIdiom == .pad {
                if score > 10 {
                   pipe2.position = CGPoint(x:(view?.frame.width)!/2-pipe1.frame.width*0.7-CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*1.25+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
                }else{
                    pipe2.position = CGPoint(x:(view?.frame.width)!/2-pipe1.frame.width*0.7-CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*0.5+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
                }
            }else{
         pipe2.position = CGPoint(x:(view?.frame.width)!/2-pipe1.frame.width*0.7-CGFloat(i)*pipe1.frame.width*0.25 , y: ((view?.frame.height)!*0.5+ball.position.y)+pipe1.frame.width*1.03*CGFloat(i))
            }
            
            pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2.size)
            pipe2.physicsBody?.mass = 3
            pipe2.physicsBody?.angularVelocity = 10000
            pipe2.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
            pipe2.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.ballCategory
            pipe2.physicsBody?.affectedByGravity = false
            pipe2.physicsBody?.pinned = true
    
            addChild(pipe1)
            addChild(pipe2)
            if i == 7 {
                heliceLastPosition = pipe2.position.y
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func pipeGenerate(){
        var n = 5
        if  UIDevice.current.userInterfaceIdiom == .pad {
            n=4
        }
        for i in 1...n{
            let pipe1 = SKSpriteNode(imageNamed: "pipe")
          
            
         
            pipe1.size = CGSize(width: (view?.frame.width)!*0.885, height: (view?.frame.height)!*0.01)

            
            if  UIDevice.current.userInterfaceIdiom == .pad {
             pipe1.position = CGPoint(x:0 , y: (heliceLastPosition)+pipe1.frame.width*0.5*CGFloat(i))
            }else{
                pipe1.position = CGPoint(x:0 , y: ((view?.frame.height)!*0.2+heliceLastPosition)+pipe1.frame.width*0.5*CGFloat(i))
            }
            
            pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
        
            pipe1.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
            pipe1.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.ballCategory
            pipe1.physicsBody?.affectedByGravity = false
            pipe1.physicsBody?.pinned = true
              pipe1.physicsBody?.mass = 1/CGFloat(i)
            pipe1.physicsBody?.allowsRotation = true
        
            
            addChild(pipe1)
         
        }
    }
    
    
    
    
    
    
    //Primeira função que fiz, gera as bolinhas normais caindo...
    func generate(){
        let obstacle = SKSpriteNode(imageNamed: "whiteBall")
        obstacle.size = CGSize(width: (view?.frame.width)!*0.06, height: (view?.frame.width)!*0.06)
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.width/2)
        obstacle.physicsBody?.affectedByGravity = false
        if UIDevice.current.userInterfaceIdiom == .pad {
           // obstacle.setScale(0.6)
        }
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory
        obstacle.physicsBody?.friction = 0
        obstacle.physicsBody?.restitution = 0
        obstacle.physicsBody?.mass = CGFloat(massObstacle)
        obstacle.zPosition = 2
        
        
        var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
        if Int(arc4random_uniform(2)) == 0 {
           random = -(random)
        }
        obstacle.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!+ball.position.y)
           obstacle.physicsBody?.velocity = CGVector(dx: 0, dy: -1100)
        addChild(obstacle)
        
        
        ball.run(SKAction.wait(forDuration: generateVelocity)) {
            if self.gameRunning == true && self.f1 == true{
            self.generate()
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //Gera as bolinhas fixas no cenário
        func generatePinned(){
           let obstacle = SKSpriteNode(imageNamed: "whiteBall")
            obstacle.size = CGSize(width: (view?.frame.width)!*0.09, height: (view?.frame.width)!*0.09)
          
            if pinnedRandom == 0 {
                if Int(arc4random_uniform(2)) == 0 {
                    obstacle.texture = SKTexture(imageNamed: "quadrado")
                }else{
                    obstacle.texture = SKTexture(imageNamed: "quadradop")
                }
              
                obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
                 obstacle.physicsBody?.allowsRotation = true
            }else{
                 obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.width/2)
                obstacle.physicsBody?.allowsRotation = false
            }
           
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.pinned = true
            
                        obstacle.zPosition = 2
            obstacle.setScale(CGFloat(scale))
   
            
            var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
            if Int(arc4random_uniform(2)) == 0 {
                random = -(random)
            }
            
            if  UIDevice.current.userInterfaceIdiom == .pad {
                obstacle.setScale(CGFloat(scale*0.85))
            }
       
            obstacle.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!+ball.position.y)
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory
            addChild(obstacle)
            
            
            ball.run(SKAction.wait(forDuration: pinnedDuration)) {
                    if self.gameRunning == true && self.f2 == true{
                self.generatePinned()
                }
            }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func generateRectangle(){
        let obstacle = SKSpriteNode(imageNamed: "pipeWhite")
    
        obstacle.size = CGSize(width: (view?.frame.width)!*0.07, height: (view?.frame.width)!*0.02)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.pinned = true
        obstacle.physicsBody?.allowsRotation = true
        obstacle.zPosition = 2
        obstacle.physicsBody?.mass = 0.05
        obstacle.physicsBody?.restitution = 1.0
        obstacle.setScale(CGFloat(scale))

        
        
        var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
        if pinnedRandom == 0 {
        if Int(arc4random_uniform(2)) == 0 {
                    obstacle.physicsBody?.allowsRotation = false
            obstacle.texture = SKTexture(imageNamed: "pipe")
            random = -(random)
        }
        }else{
            retanguloTime = 0.085*(1.025-(Double(ballLevel)*0.02))
            if Int(arc4random_uniform(2)) == 0 {
                random = -(random)
            }
        }
        
        
        obstacle.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!+ball.position.y)
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory | PhysicsCategory.ballCategory
      
         addChild(obstacle)
//vorta
        ball.run(SKAction.wait(forDuration: retanguloTime)) {
            if self.gameRunning == true && self.f4 == true {
                self.generateRectangle()
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //Cria vários nodes pequenos praticamente sem massa, mais pela animação que dá ao jogo...Terei que mudar a quantidade para outros aparelhos pois pode acabar travando...
    func barreira(){
        for _ in 1...80 {
       let obstacle = SKSpriteNode(imageNamed: "blackBall")
        obstacle.size = CGSize(width: (view?.frame.width)!*0.07, height: (view?.frame.width)!*0.07)
        obstacle.physicsBody?.affectedByGravity = true
            obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.width/2)
            obstacle.physicsBody?.mass = 0.0001
            obstacle.zPosition = 2
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.deleterCategory
        if UIDevice.current.userInterfaceIdiom == .pad {
         //   obstacle.setScale(0.6)
        }
           
        
        var random = CGFloat(arc4random_uniform(UInt32((view?.frame.width)!/2)))
        if Int(arc4random_uniform(2)) == 0 {
            random = -(random)
        }
        obstacle.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))

        obstacle.position = CGPoint(x: CGFloat(random), y: (view?.frame.height)!*0.65+ball.position.y)
         
    
        obstacle.physicsBody?.velocity = CGVector(dx: 0, dy: -1100)
        addChild(obstacle)
    }
        
        ball.run(SKAction.wait(forDuration: 1.5), completion:
            {
            if self.barreiraCalled == false && self.gameRunning == true {
                self.barreiraCalled = true
            self.barreira()
                }
            })
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getClock(){
          ball.run(SKAction.playSoundFileNamed("clockSound", waitForCompletion: false))
        let nTime = Int(arc4random_uniform(3))+3
        timerMore = TimeInterval(nTime)
        if newClock == true {
            timerLabel.fontColor = UIColor.white
            if conferidorChoose == 1{
                timerMore = TimeInterval(56)
                newClock = false
            }else if conferidorChoose == 2{
                timerMore = TimeInterval(40)
           if UIDevice.current.userInterfaceIdiom == .pad {
                self.timerCount += 2
                }
                newClock = false
            }
            
        }
        timerCount += timerMore
        if timerCount <= 5 {
            timerLabel.fontColor = UIColor.red
        }else{
            timerLabel.fontColor = UIColor.white
        }
      self.timerLabel.text = "\(Int(self.timerCount))"
    
    }
    
    

    //Esta função controla todo o contato físico dos elementos
    func didBegin(_ contact: SKPhysicsContact) {
        if gameRunning == true {

            if bitelaAway == true {
            if contact.bodyA.categoryBitMask == PhysicsCategory.gigaCategory && contact.bodyB.categoryBitMask == PhysicsCategory.pipeCategory  {
                contact.bodyA.node?.removeAllActions()
                contact.bodyA.node?.removeFromParent()
            }
                
            
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.pipeCategory && contact.bodyB.categoryBitMask == PhysicsCategory.gigaCategory  {
                contact.bodyB.node?.removeAllActions()
                contact.bodyB.node?.removeFromParent()
            }
            }
            
        if contact.bodyA.categoryBitMask == PhysicsCategory.clockCategory && contact.bodyB.categoryBitMask == PhysicsCategory.ballCategory  {
            contact.bodyA.node?.removeAllActions()
            contact.bodyA.node?.removeFromParent()
            getClock()
            
        }
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.ballCategory && contact.bodyB.categoryBitMask == PhysicsCategory.clockCategory  {
              contact.bodyB.node?.removeAllActions()
            contact.bodyB.node?.removeFromParent()
           getClock()
        }
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.clockCategory  && contact.bodyB.categoryBitMask == PhysicsCategory.obstacleCategory  {
            contact.bodyB.node?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.obstacleCategory && contact.bodyB.categoryBitMask == PhysicsCategory.clockCategory  {
            contact.bodyA.node?.removeFromParent()
        }
        
        //Se o poder de remoção estiver ativado a bolinha remove qualquer obstaculo que tocar:
        if removerActive == true {
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.obstacleCategory || contact.bodyA.categoryBitMask == PhysicsCategory.gigaCategory || contact.bodyA.categoryBitMask == PhysicsCategory.pipeCategory && contact.bodyB.categoryBitMask == PhysicsCategory.ballCategory  {
                contact.bodyA.node?.removeFromParent()
                
            }
            
            if  contact.bodyA.categoryBitMask == PhysicsCategory.ballCategory && contact.bodyB.categoryBitMask == PhysicsCategory.obstacleCategory || contact.bodyB.categoryBitMask == PhysicsCategory.pipeCategory || contact.bodyB.categoryBitMask == PhysicsCategory.gigaCategory {
                contact.bodyB.node?.removeFromParent()
            }
        }
   
        
        
        
        //Remover nodes ao tocar no deleter
        if contact.bodyA.categoryBitMask == PhysicsCategory.obstacleCategory && contact.bodyB.categoryBitMask == PhysicsCategory.deleterCategory  {
 contact.bodyA.node?.removeFromParent()
        }
        
        if  contact.bodyA.categoryBitMask == PhysicsCategory.deleterCategory && contact.bodyB.categoryBitMask == PhysicsCategory.obstacleCategory{
         contact.bodyB.node?.removeFromParent()
    }
        
        
        }
    }
 
    


    
    
    
    
    
    
    
    
    
    
    
    
    


    
      override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "FantasticInventionsFM", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
}
        
         scene?.physicsWorld.speed = 0
GADRewardBasedVideoAd.sharedInstance().delegate = self
 scene?.scaleMode = .aspectFill
      gameRunning = false
physicsWorld.contactDelegate = self
        scene?.isPaused = false


        adsBt = SKSpriteNode(imageNamed: "adsBt")
        title = SKSpriteNode(imageNamed: "title")
        
        
        //HIGHSCORE é resgatado caso tenha sido salvo, caso não, será 0
        if Int(UserDefaults.standard.integer(forKey: "bestscoreSaved")) > 0 {
            bestScore = Int(UserDefaults.standard.integer(forKey: "bestscoreSaved"))
            bestScoreLabel.text = "BEST: \(bestScore)"
        }else{
            bestScore = 0
            bestScoreLabel.text = "BEST: \(bestScore)"
        }
        
 
        
        
        //Vai ser false apenas uma vez para definir o número de 3 poderes de cada! Depois disso vai ser true e salvar/pegar o número que o usuário possuir.
        if UserDefaults.standard.bool(forKey: "firstSave") == false {
            UserDefaults.standard.set(3, forKey: "deleterSaved")
                UserDefaults.standard.set(3, forKey: "resizeSaved")
            UserDefaults.standard.set(1500, forKey: "colorBallsSaved")
              UserDefaults.standard.set(1, forKey: "ballLevelSaved")
              UserDefaults.standard.set(2000, forKey: "ballValueSaved")
            
            //Nunca mais vai ocorrer:
            UserDefaults.standard.set(true, forKey: "firstSave")
               UserDefaults.standard.synchronize()
            
              deleterNumber = Int(UserDefaults.standard.integer(forKey: "deleterSaved"))
              resizeNumber = Int(UserDefaults.standard.integer(forKey: "resizeSaved"))
              colorBalls = Int(UserDefaults.standard.integer(forKey: "colorBallsSaved"))
             ballLevel = Int(UserDefaults.standard.integer(forKey: "ballLevelSaved"))
            ballValue = Int(UserDefaults.standard.integer(forKey: "ballValueSaved"))
            deleterNumberLabel.text = "\(deleterNumber)"
            ballLevelLabel.text = "\(ballLevel)"
            resizeNumberLabel.text = "\(resizeNumber)"
              colorBallLabel.text = "\(colorBalls)"
            upgradeBallLabel.text = "\(ballValue)"
            
            //PRONTO, AQUI VAI SER O CÓDIGO QUE RODA EM QUALQUER JOGO DPS
        }else {
             deleterNumber = Int(UserDefaults.standard.integer(forKey: "deleterSaved"))
            resizeNumber = Int(UserDefaults.standard.integer(forKey: "resizeSaved"))
             colorBalls = Int(UserDefaults.standard.integer(forKey: "colorBallsSaved"))
              ballLevel = Int(UserDefaults.standard.integer(forKey: "ballLevelSaved"))
              ballValue = Int(UserDefaults.standard.integer(forKey: "ballValueSaved"))
              colorBallLabel.text = "\(colorBalls)"
             ballLevelLabel.text = "\(ballLevel)"
            deleterNumberLabel.text = "\(deleterNumber)"
            resizeNumberLabel.text = "\(resizeNumber)"
               upgradeBallLabel.text = "\(ballValue)"
 
        }

        
        if ballLevel == 1 {
            buyUpgrade.texture = SKTexture(imageNamed: "up1")
        }else if ballLevel == 2 {
            buyUpgrade.texture = SKTexture(imageNamed: "up2")
        }else if ballLevel == 3 {
            buyUpgrade.texture = SKTexture(imageNamed: "up3")
        }else if ballLevel == 4 {
            buyUpgrade.texture = SKTexture(imageNamed: "up4")
        }else if ballLevel == 5 {
            buyUpgrade.texture = SKTexture(imageNamed: "up5")
        }else if ballLevel == 6 {
            buyUpgrade.texture = SKTexture(imageNamed: "upmax")
        }
        
       
  
        
        
        
        
        //CONFIGURAÇÃO DOS LABELS DE SCORE E TEMPO:
        scoreLabel.alpha = 0
        timerLabel.alpha = 0
        scoreLabel.fontSize = 50
        timerLabel.fontSize = 35
        
        scoreLabel.text = "0"
        timerLabel.text = "\(timerCount)"
        scoreLabel.position = CGPoint(x: 0, y:view.frame.height*0.25)
        timerLabel.position = CGPoint(x: 0, y:view.frame.height*0.25-scoreLabel.frame.height)
        myCamera.addChild(scoreLabel)
        myCamera.addChild(timerLabel)
        
        
        
         self.camera = myCamera
        self.addChild(myCamera)
        camera?.position = CGPoint(x: 0, y: 0+view.frame.height/2)

        
        ball.size = CGSize(width: view.frame.width*0.08, height: view.frame.width*0.08)
        ball.position = CGPoint(x: 0, y: view.frame.height*0.45)
        ball.zPosition = 5
         ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)

      ball.physicsBody?.friction = 0
        ball.physicsBody?.allowsRotation = false
        
        
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.obstacleCategory | PhysicsCategory.clockCategory | PhysicsCategory.pipeCategory | PhysicsCategory.gigaCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategory.obstacleCategory | PhysicsCategory.pipeCategory | PhysicsCategory.gigaCategory
        ball.physicsBody?.linearDamping = 0.8
        ball.physicsBody?.restitution = 0.2
        ball.physicsBody?.mass = 0.1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.usesPreciseCollisionDetection = true
        addChild(ball)

        colorBt.size = CGSize(width: view.frame.width*0.095, height: view.frame.width*0.095)
        colorBt.position = CGPoint(x: view.frame.width*0.5-colorBt.frame.width*1.5, y: view.frame.height*0.94-colorBt.frame.height)
        colorBt.zPosition = 11
       // addChild(colorBt)

        adsBt.size = CGSize(width: view.frame.width*0.11, height: view.frame.width*0.11)
     //   adsBt.position = CGPoint(x: view.frame.width*0.5-colorBt.frame.width*1.5, y: view.frame.height*0.94-colorBt.frame.height-adsBt.frame.height*1.25)
       adsBt.position =  CGPoint(x: view.frame.width*0.5-colorBt.frame.width*1.5, y: view.frame.height*0.95-colorBt.frame.height)
        adsBt.zPosition = 11
        addChild(adsBt)
        
        rankBt.size = CGSize(width: view.frame.width*0.11, height: view.frame.width*0.11)
        rankBt.position = CGPoint(x: -view.frame.width*0.5+colorBt.frame.width*1.5, y: view.frame.height*0.95-colorBt.frame.height)
        rankBt.zPosition = 11
        addChild(rankBt)
        
        


        resizeBt.size = CGSize(width: view.frame.width*0.11, height: view.frame.width*0.11)
        resizeBt.position = CGPoint(x: 0-resizeBt.frame.width, y: view.frame.height*0.44-resizeBt.frame.height*1.25)
        resizeBt.zPosition = 90
        resizeBt.alpha = 0
        myCamera.addChild(resizeBt)
        
        removerBt.size = CGSize(width: view.frame.width*0.11, height: view.frame.width*0.11)
        removerBt.position = CGPoint(x: 0+removerBt.frame.width, y: view.frame.height*0.44-removerBt.frame.height*1.25)
        removerBt.zPosition = 90
        removerBt.alpha = 0
        myCamera.addChild(removerBt)
        
        
        
        
        
        
        
       
        
        colorBallNode.size = CGSize(width: view.frame.width*0.1, height: view.frame.width*0.1)
        colorBallNode.zPosition = 99
        colorBallNode.position = CGPoint(x: 0, y: view.frame.height*0.95-colorBallNode.frame.height*1.25)
       addChild(colorBallNode)

        colorBallLabel.text = "\(colorBalls)"
        colorBallLabel.fontName = "Cabana"
        colorBallLabel.fontColor = UIColor.black
        colorBallLabel.alpha = 1
        colorBallLabel.fontSize = 35
        colorBallLabel.zPosition = 102
         colorBallLabel.position = CGPoint(x: 0, y: colorBallNode.position.y-colorBallNode.frame.height*0.5-colorBallLabel.frame.height)
addChild(colorBallLabel)
        

        
        colorBt.alpha = 0.8
        adsBt.alpha = 0.8
        buyBt.alpha = 0.8
        rankBt.alpha = 0.8
        
        
        title.size = CGSize(width: view.frame.width*0.7, height: view.frame.width*0.37)
        title.position = CGPoint(x: 0, y: view.frame.height*0.62+title.frame.height*0.5)
        title.zPosition = 11
   title.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.1, duration: 1.6),SKAction.scale(to: 1, duration: 1.6)])))
        addChild(title)
        
       
buyColorBall.size = CGSize(width: view.frame.width*0.215, height: view.frame.width*0.253)
buyColorBall.position = CGPoint(x: 0+view.frame.width*0.338, y: view.frame.height*0.24)
buyColorBall.zPosition = 11
addChild(buyColorBall)

        
        buyResize.size = CGSize(width: view.frame.width*0.215, height: view.frame.width*0.253)
        buyResize.position = CGPoint(x: 0+view.frame.width*0.113, y: view.frame.height*0.24)
        buyResize.zPosition = 11
        addChild(buyResize)
  
        
        
        buyDeleter.size = CGSize(width: view.frame.width*0.215, height: view.frame.width*0.253)
        buyDeleter.position = CGPoint(x: 0-view.frame.width*0.112, y: view.frame.height*0.24)
        buyDeleter.zPosition = 11
        addChild(buyDeleter)
 
        
        
        buyUpgrade.removeAllActions()
        buyUpgrade.size = CGSize(width: view.frame.width*0.215, height: view.frame.width*0.253)
        buyUpgrade.position = CGPoint(x: 0-view.frame.width*0.138-view.frame.width*0.2, y: view.frame.height*0.24)
        buyUpgrade.alpha = 1
        buyUpgrade.zPosition = 11
        addChild(buyUpgrade)
  
      
        
       
        
        
        
        
        
        upgradeBallLabel.removeAllActions()
    resizeNumberLabel.removeAllActions()
         ballLevelLabel.removeAllActions()
        deleterNumberLabel.removeAllActions()
        resizeNumberLabel.removeFromParent()
        deleterNumberLabel.removeFromParent()
        
        deleterNumberLabel.fontName = "Cabana"
        deleterNumberLabel.fontSize = 20 //20 fica legal no jogo
        deleterNumberLabel.zPosition = 100
        deleterNumberLabel.fontColor = UIColor.black
        deleterNumberLabel.alpha = 1
        deleterNumberLabel.position = CGPoint(x: -view.frame.width*0.112, y: buyDeleter.position.y+deleterNumberLabel.frame.height*1.7)
        addChild(deleterNumberLabel)

        resizeNumberLabel.fontName = "Cabana"
        resizeNumberLabel.fontSize = 20
        resizeNumberLabel.zPosition = 100
         resizeNumberLabel.alpha = 1
        resizeNumberLabel.fontColor = UIColor.black
         addChild(resizeNumberLabel)
      resizeNumberLabel.position = CGPoint(x: view.frame.width*0.113, y: buyDeleter.position.y+deleterNumberLabel.frame.height*1.7)
        
        
 
        
        
 
        upgradeBallLabel.removeAllActions()
            upgradeBallLabel.removeFromParent()
        upgradeBallLabel.fontName = "Myriad Pro"
        upgradeBallLabel.fontSize = 18
        upgradeBallLabel.zPosition = 100
        upgradeBallLabel.alpha = 1
        upgradeBallLabel.fontColor = UIColor.white
       // addChild(upgradeBallLabel)
        upgradeBallLabel.position = CGPoint(x: -view.frame.width*0.366, y: buyDeleter.position.y-buyDeleter.frame.height*0.435)
        if ballValue > 9999 {
            upgradeBallLabel.fontSize = 15
            upgradeBallLabel.position = CGPoint(x: -view.frame.width*0.366, y: buyDeleter.position.y-buyDeleter.frame.height*0.43)
        }
        
        
        
        
        //Verifica a quantidade de colorBalls, e se esta quantidade é capaz de comprar algum poder. O poder que puder ser comprado é deixado com alpha = 1, caso não puder por quantidade insuficiente será deixado com alpha = 0.4
        if colorBalls >= 1200 {
            buyDeleter.alpha = 1
        }else{
            buyDeleter.alpha = 0.4
            deleterNumberLabel.alpha = 0.4
        }
        
        if colorBalls >= 800 {
            buyResize.alpha = 1
        }else{
            buyResize.alpha = 0.4
            resizeNumberLabel.alpha = 0.4
        }
        
        if colorBalls >= ballValue {
            buyUpgrade.alpha = 1
        }else{
            if ballLevel == 6 {
                buyUpgrade.alpha = 1
            }else{
                buyUpgrade.alpha = 0.4
            }
        }
        
        
        bestScoreLabel.position = CGPoint(x: 0, y: title.position.y-title.frame.height*0.65-bestScoreLabel.frame.height)
        bestScoreLabel.fontName = "Cabana"
        bestScoreLabel.fontSize = 50
        bestScoreLabel.zPosition = 99
        bestScoreLabel.alpha = 0.85
        bestScoreLabel.fontColor = UIColor.white
        addChild(bestScoreLabel)
        
    
        
        
        
        continueLabel.text = "YOU ARE OUT OF TIME!"
        continueLabel.fontName = "Cabana"
        continueLabel.fontSize = 65
        continueLabel.zPosition = 99
        continueLabel.alpha = 0
        continueLabel.fontColor = UIColor.black
        continueLabel.position = CGPoint(x: -view.frame.width*0.8, y: view.frame.height*0.8-continueLabel.frame.height)
        addChild(continueLabel)
        
        
        restartLabel.text = "RESTART"
        restartLabel.fontName = "Cabana"
        restartLabel.fontSize = 40
        restartLabel.zPosition = 99
        restartLabel.alpha = 1
        restartLabel.fontColor = UIColor.white
        restartLabel.position = CGPoint(x: -view.frame.width*0.8, y: view.frame.height*0.8-continueLabel.frame.height)
        addChild(restartLabel)
        
         continueAd.size = CGSize(width: view.frame.width*0.5, height: view.frame.width*0.17)
        continueAd.position = CGPoint(x: -view.frame.width*2, y: view.frame.height*0.25-continueAd.frame.height)
        continueAd.zPosition = 99
        continueAd.alpha = 0
        addChild(continueAd)
     
   
       
        
        //O chão (grama) que eu coloquei pra iniciar o jogo
        ground.size = CGSize(width: view.frame.width, height: view.frame.height*0.11)
        ground.position = CGPoint(x: 0, y: ground.frame.height*0.9)
        addChild(ground)
        
        deleter.size = CGSize(width: view.frame.width*2, height: view.frame.height*0.03)
          deleter.position = CGPoint(x: 0, y: ball.position.y - view.frame.height)
        deleter.alpha = 0
        addChild(deleter)
        
        
        

        
       
        

        
        
        leftText.size = CGSize(width: view.frame.width*0.15, height: view.frame.width*0.15)
        leftText.position = CGPoint(x: -view.frame.width*0.3, y: view.frame.height*0.48)
        leftText.zPosition = 11
        leftText.alpha = 0.6
        addChild(leftText)
    
        
        rightText.size = CGSize(width: view.frame.width*0.15, height: view.frame.width*0.15)
        rightText.position = CGPoint(x: view.frame.width*0.3, y: view.frame.height*0.48)
        rightText.zPosition = 11
        rightText.alpha = 0.6
        addChild(rightText)
    
        
        wallLeft.size = CGSize(width: view.frame.width*0.5, height: view.frame.height*10)
        wallLeft.position = CGPoint(x: -view.frame.width*0.5-wallLeft.frame.width*0.5+ball.frame.width/2, y: wallLeft.frame.height*0.5)
        wallLeft.alpha = 0
        wallLeft.zPosition = 0
  addChild(wallLeft)
        
        

       wallRight.size = CGSize(width: view.frame.width*0.05, height: view.frame.height*10)
          wallRight.position = CGPoint(x: view.frame.width*0.5+wallLeft.frame.width*0.5-ball.frame.width/2, y: wallLeft.frame.height*0.5)
         wallRight.zPosition = 0
        wallRight.alpha = 0
 addChild(wallRight)

        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.friction = 1
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.friction = 1
        ground.physicsBody?.restitution = 0
        
        deleter.physicsBody = SKPhysicsBody(rectangleOf: deleter.size)
        deleter.physicsBody?.allowsRotation = false
        deleter.alpha = 0
        deleter.physicsBody?.categoryBitMask = PhysicsCategory.deleterCategory
        deleter.physicsBody?.contactTestBitMask = PhysicsCategory.obstacleCategory
        
        wallLeft.physicsBody = SKPhysicsBody(rectangleOf: wallLeft.size)
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.mass = 50
        wallLeft.physicsBody?.friction = 0.2
        
        wallRight.physicsBody = SKPhysicsBody(rectangleOf: wallLeft.size)
        wallRight.physicsBody?.isDynamic = false
        wallRight.physicsBody?.mass = 50
        wallRight.physicsBody?.friction = 0.2

       
  
        
        
        //Pra ver tudo:
// camera?.setScale(5)
        print(view.bounds.width)
  if UIDevice.current.userInterfaceIdiom == .pad {

    
scoreLabel.fontSize = 120
    timerLabel.fontSize = 80
    ball.setScale(0.7)
   
     title.position = CGPoint(x: 0, y: view.frame.height*0.59+title.frame.height*0.5)
    bestScoreLabel.fontSize = 80
       bestScoreLabel.position = CGPoint(x: 0, y: title.position.y-title.frame.height*0.6-bestScoreLabel.frame.height)
  
       ground.position = CGPoint(x: 0, y: ground.frame.height*0.45)
    
    adsBt.setScale(0.9)
    rankBt.setScale(0.9)
    colorBallNode.setScale(0.9)
    colorBallLabel.fontSize = 50

    
    adsBt.position =  CGPoint(x: view.frame.width*0.55-colorBt.frame.width*1.2, y: view.frame.height*1.01-colorBt.frame.height)
    rankBt.position = CGPoint(x: -view.frame.width*0.55+colorBt.frame.width*1.2, y: view.frame.height*1.01-colorBt.frame.height)
    colorBallNode.position = CGPoint(x: 0, y: view.frame.height*1.01-colorBallNode.frame.height)
    colorBallLabel.position = CGPoint(x: 0, y: colorBallNode.position.y-colorBallNode.frame.height*0.5-colorBallLabel.frame.height)
   
    

    
    deleterNumberLabel.fontSize = 45
    resizeNumberLabel.fontSize = 45
  deleterNumberLabel.position = CGPoint(x: -view.frame.width*0.112, y: view.frame.height*0.3)
  resizeNumberLabel.position = CGPoint(x: view.frame.width*0.113, y: view.frame.height*0.3)
    
   
    
    
    
    //elementos durante o jogo
    scoreLabel.position = CGPoint(x: 0, y:view.frame.height*0.11)
    timerLabel.position = CGPoint(x: 0, y:view.frame.height*0.11-scoreLabel.frame.height)
    resizeBt.setScale(0.55)
     removerBt.setScale(0.55)
    resizeBt.position = CGPoint(x: 0-resizeBt.frame.width, y: view.frame.height*0.27-resizeBt.frame.height)
    removerBt.position = CGPoint(x: 0+removerBt.frame.width, y: view.frame.height*0.27-removerBt.frame.height)
    
    
   
    //abaxapad

  }else{
    if view.bounds.height == 812.0{
print("222222222")
        camera?.setScale(0.905)
        resizeBt.position = CGPoint(x: 0-resizeBt.frame.width, y: view.frame.height*0.48-resizeBt.frame.height)
        removerBt.position = CGPoint(x: 0+removerBt.frame.width, y: view.frame.height*0.48-removerBt.frame.height)
        
    }else{
        resizeBt.position = CGPoint(x: 0-resizeBt.frame.width, y: view.frame.height*0.48-resizeBt.frame.height)
        removerBt.position = CGPoint(x: 0+removerBt.frame.width, y: view.frame.height*0.48-removerBt.frame.height)
         camera?.setScale(0.9)
        colorBallLabel.setScale(0.85)
        colorBallNode.position = CGPoint(x: 0, y: adsBt.position.y)
          colorBallLabel.position = CGPoint(x: 0, y: colorBallNode.position.y-colorBallNode.frame.height*0.5-colorBallLabel.frame.height)
        deleterNumberLabel.position = CGPoint(x: -view.frame.width*0.112, y: view.frame.height*0.282)
        resizeNumberLabel.position = CGPoint(x: view.frame.width*0.113, y: view.frame.height*0.282)
    }
    
    
    }

    
    
    

        
        
        
        //Aqui verifica-se se o jogador comprou a remoção de anúncios para impedir que vídeos sejam mostrados
        if UserDefaults.standard.bool(forKey: "adsRemovedSaved") == true {
            adsMustLoad = false
            //Fica aqui embaixa de tudo pois junto com os outros userdefaults fica antes da declaracao do adsbt e o alpha nao é setado corretamente:
            adsBt.alpha = 0.3
        }
        

        
        if logoBool == true {
            grdevNode.size = CGSize(width: view.frame.width*0.55, height: view.frame.width*0.578)
            grdevNode.position = CGPoint(x: 0, y: view.frame.height*0.5)
            grdevNode.zPosition = 200
            grdevNode.alpha = 1
            addChild(grdevNode)
            
            
            colorBlack.size = CGSize(width: view.frame.width*1.1, height: view.frame.height*1.1)
            colorBlack.position = CGPoint(x: 0, y: view.frame.height*0.5)
            colorBlack.zPosition = 199
            colorBlack.alpha = 1
            addChild(colorBlack)
            
            grdevNode.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.fadeOut(withDuration: 0.5)]))
            colorBlack.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.fadeOut(withDuration: 0.5)]), completion:
                {
                    self.canStart = true
                    self.addChild(self.backgroundMusic)
                    self.grdevNode.removeFromParent()
                    self.colorBlack.removeFromParent()
            })
            
        }else{
            self.canStart = true
            self.addChild(self.backgroundMusic)
        }
 
        


    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func resizeBall(){
        if resizeNumber > 0 {
        resizeBt.alpha = 0.3
        //vai mudar o tamanho da bolinha conforme o level
        if  resizeUsed == false {
            resizeUsed = true
        ball.setScale(CGFloat(1.0-(scaleLevel*0.05)))
   
        ball.physicsBody?.mass = CGFloat(0.1/(1+ball.xScale))

            resizeBt.run(SKAction.wait(forDuration: TimeInterval(5+(ballLevel-1)*1))) {
                self.ball.setScale(1)
 if UIDevice.current.userInterfaceIdiom == .pad {
                self.ball.setScale(0.7)
                }
                      self.ball.physicsBody?.mass = 0.1
                self.ball.physicsBody?.linearDamping = 0.8
                self.ball.physicsBody?.restitution = 0.2
                self.ball.physicsBody?.friction = 0
                self.ball.physicsBody?.categoryBitMask = PhysicsCategory.ballCategory
                self.ball.physicsBody?.contactTestBitMask = PhysicsCategory.obstacleCategory
                 self.resizeBt.run(SKAction.wait(forDuration: 60)) {
                     self.resizeUsed = false
                      if self.resizeNumber > 0 {
                    self.resizeBt.alpha = 1
                    }
                }
            }
        }
        resizeNumber -= 1
        UserDefaults.standard.set(resizeNumber, forKey: "resizeSaved")
        UserDefaults.standard.synchronize()
        resizeNumberLabel.text = "\(resizeNumber)"
        }
    }
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Função que ativa o poder de remover os nodes tocados
    func removerFunc(){
        if deleterNumber > 0 {
        removerUsed = true
        removerActive = true
        removerBt.alpha = 0.3
            removerBt.run(SKAction.wait(forDuration: TimeInterval(5+(ballLevel-1)*1))) {
            self.removerActive = false
            self.removerBt.run(SKAction.wait(forDuration: 60)) {
                self.removerUsed = false
                 if self.deleterNumber > 0 {
                self.removerBt.alpha = 1
                }
            }
        }
            
        deleterNumber -= 1
            
        UserDefaults.standard.set(deleterNumber, forKey: "deleterSaved")
        UserDefaults.standard.synchronize()
            deleterNumberLabel.text = "\(deleterNumber)"
        }
    }
    
    
    
    
    
    //abaxaqui
    
    //Função do poder que deixa a bolinha pequena
    func buyResizeFunc(){
        if colorBalls >= 800 {
            ball.run(SKAction.playSoundFileNamed("upgrade", waitForCompletion: false))
            colorBalls -= 800
            UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
  colorBallLabel.text = "\(colorBalls)"
            resizeNumber += 1
            UserDefaults.standard.set(deleterNumber, forKey: "resizeSaved")
            UserDefaults.standard.synchronize()
            resizeNumberLabel.text = "\(resizeNumber)"
            if colorBalls >= 1200 {
                buyDeleter.alpha = 1
                deleterNumberLabel.alpha =  1
            }else{
                buyDeleter.alpha = 0.4
                deleterNumberLabel.alpha =  0.4
            }
            if colorBalls >= 800 {
                buyResize.alpha = 1
                resizeNumberLabel.alpha = 1
            }else{
                resizeNumberLabel.alpha = 0.4
                buyResize.alpha = 0.4
            }
        }
    }
    
    
    
    
    
    func buyDeleterFunc(){
        if colorBalls >= 1200 {
             ball.run(SKAction.playSoundFileNamed("upgrade", waitForCompletion: false))
        colorBalls -= 1200
        UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
              colorBallLabel.text = "\(colorBalls)"
        deleterNumber += 1
        UserDefaults.standard.set(deleterNumber, forKey: "deleterSaved")
        UserDefaults.standard.synchronize()
            deleterNumberLabel.text = "\(deleterNumber)"
            if colorBalls >= 1200 {
                buyDeleter.alpha = 1
                deleterNumberLabel.alpha =  1
            }else{
                 buyDeleter.alpha = 0.4
                deleterNumberLabel.alpha =  0.4
            }
            if colorBalls >= 800 {
                buyResize.alpha = 1
                resizeNumberLabel.alpha = 1
            }else{
                resizeNumberLabel.alpha = 0.4
                buyResize.alpha = 0.4
            }
        }
    }
    
    
    
    
    
    
    
    
    //aquii
    func buyUpgradeFunc(){
        if ballLevel < 6 {
        if colorBalls >= ballValue {
            ball.run(SKAction.playSoundFileNamed("upgrade", waitForCompletion: false))
            colorBalls -= ballValue
            UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
            colorBallLabel.text = "\(colorBalls)"
            ballLevel += 1
            ballValue = ballValue + 1000*ballLevel + 1000
            UserDefaults.standard.set(ballLevel, forKey: "ballLevelSaved")
            UserDefaults.standard.set(ballValue, forKey: "ballValueSaved")
            UserDefaults.standard.synchronize()
            colorBallLabel.text = "\(colorBalls)"
            ballLevelLabel.text = "\(ballLevel)"
            upgradeBallLabel.text = "\(ballValue)"
            if ballLevel == 1 {
                buyUpgrade.texture = SKTexture(imageNamed: "up1")
            }else if ballLevel == 2 {
                buyUpgrade.texture = SKTexture(imageNamed: "up2")
            }else if ballLevel == 3 {
                buyUpgrade.texture = SKTexture(imageNamed: "up3")
            }else if ballLevel == 4 {
                buyUpgrade.texture = SKTexture(imageNamed: "up4")
            }else if ballLevel == 5 {
                buyUpgrade.texture = SKTexture(imageNamed: "up5")
            }else if ballLevel == 6 {
                buyUpgrade.texture = SKTexture(imageNamed: "upmax")
            }
            
            if colorBalls >= 1200 {
                buyDeleter.alpha = 1
                deleterNumberLabel.alpha =  1
            }else{
                buyDeleter.alpha = 0.4
                deleterNumberLabel.alpha =  0.4
            }
            if colorBalls >= 800 {
                buyResize.alpha = 1
                resizeNumberLabel.alpha = 1
            }else{
                resizeNumberLabel.alpha = 0.4
                buyResize.alpha = 0.4
            }
            if colorBalls >= ballValue {
                buyUpgrade.alpha = 1
            }else{
                if ballLevel == 6 {
                    buyUpgrade.alpha = 1
                }else{
                buyUpgrade.alpha = 0.4
                }
            }
            
            
            
            
        }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
  let touch = touches.first!
        let touchPosition = touch.location(in: self)
       let cameraLocation = touch.location(in: myCamera)
        //se o jogo não estiver rodando, comece....faltam coisas:
        //Cuidado com isso pois pode fazer o jogo começar em qualquer momento!!!
           if gameRunning == false && isGameOver == false && adsBt.contains(touch.location(in: self)) || rankBt.contains(touch.location(in: self)) || buyColorBall.contains(touch.location(in: self))  || buyDeleter.contains(touch.location(in: self)) || buyResize.contains(touch.location(in: self)) || buyUpgrade.contains(touch.location(in: self)){
           }else if gameRunning == false && isGameOver == false && (scene?.contains(touch.location(in: self)))!{
            if canStart == true{
                logoBool = false
            start()
            }
        }
        
        if buyDeleter.contains(touch.location(in: self)) && gameRunning == false {
            buyDeleterFunc()
        }
        if buyResize.contains(touch.location(in: self)) && gameRunning == false {
            buyResizeFunc()
        }
        if buyUpgrade.contains(touch.location(in: self)) && gameRunning == false {
            buyUpgradeFunc()
        }

             if gameRunning == false && continueAd.contains(touch.location(in: self)) {
                if adsMustLoad == true{
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
                }else{
                    presentScene()
                }
        }
        
        if gameRunning == false && rankBt.contains(touch.location(in: self)) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openGameCenterObserver"), object: nil)
        }
        
        

        
         if gameRunning == false && adsBt.contains(touch.location(in: self)) && adsMustLoad == true {
            //Remover anúncios
            productBuy = "removeAdsProductStr"
             IAPService.shared.purchase(product: .removeAdsProduct)
        }
        
        if gameRunning == false && buyColorBall.contains(touch.location(in: self)) {
            //Remover anúncios
            productBuy = "colorBallsBuy"
            IAPService.shared.purchase(product: .colorBallsProduct)
        }
        
      
        if gameRunning == false && restartLabel.contains(touch.location(in: self)) {
            if adsMustLoad == true{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInterObserver"), object: nil)
        presentScene()
            }else{
                  presentScene()
            }
        }
        
        
        //se o jogo estiver rodando, faz as coisas
        if gameRunning == true && isGameOver == false {
            
            if resizeBt.contains(cameraLocation) {
                if resizeUsed == false {
                resizeBall()
                }
            }
            if removerBt.contains(cameraLocation) {
                if  removerActive == false && removerUsed == false {
                    removerFunc()
                }
            }
           
            
              var distance = touchPosition.x
        if distance < 0 {
                 distance = 200
        }else if distance > 0 {
                distance = -200
        }
            
            

        if (scene?.contains(touch.location(in: self)))! && colorBt.contains(touch.location(in: self)) || adsBt.contains(touch.location(in: self)) || resizeBt.contains(touch.location(in: self)){
            
        }else if (scene?.contains(touch.location(in: self)))!{
            //58
            if currentFPS >= 1 {
                let FPSNow = currentFPS
                if FPSNow >= 1 {
                    if ball.position.x > (view?.frame.width)!*0.52 || ball.position.x < -(view?.frame.width)!*0.52 {
                        ball.position.x = 0
                    }
            ball.physicsBody?.velocity.dx = 0
            ball.physicsBody?.velocity.dy = 0

            let ballForce = CGPoint(x: ball.position.x, y: ball.position.y-ball.frame.height*0.4)
            
                
            if UIDevice.current.userInterfaceIdiom == .pad {
                if ballLevel <= 5 {
                    ball.physicsBody?.applyForce(CGVector(dx: -distance*5, dy: 2800.0*((CGFloat(ballLevel))*0.02+0.98)), at:ballForce) //3000
                }else if ballLevel > 5{
                    ball.physicsBody?.applyForce(CGVector(dx: -distance*5, dy: 2800.0*(5.0*0.02+0.98)), at:ballForce) //3000
                }
            }else{
                if ballLevel <= 5 {
                 ball.physicsBody?.applyForce(CGVector(dx: -distance*5, dy: 3000.0*((CGFloat(ballLevel))*0.02+0.98)), at:ballForce) //3000
                }else if ballLevel > 5{
                     ball.physicsBody?.applyForce(CGVector(dx: -distance*5, dy: 3000.0*(5.0*0.02+0.98)), at:ballForce) //3000
                }
            }
                ball.run(SKAction.playSoundFileNamed("hover", waitForCompletion: false))
            }
            }
          
            scoreLabel.text = "\(score)"
          
            }}}
    
    

    
    
    
    
    
    
    
    

    

    override func sceneDidLoad() {
        //Aqui verifica-se se o jogador comprou a remoção de anúncios para impedir que vídeos sejam mostrados
        if UserDefaults.standard.bool(forKey: "adsRemovedSaved") == false {
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                        withAdUnitID: "cac-app-pub-8409835855520197/4437943235")
        }
    }
    

    
    
    
    
    
    func gameOver2(){
        
        if ball.position.y < positionGameOver - (view?.frame.height)! {
            continueLabel.text = "GAME OVER"
            gameOverFunc()
        }
        
        ball.run(SKAction.wait(forDuration: 2)) {
            if self.isGameOver == false && self.gameRunning == true {
                self.gameOver2()
            }
    }
    }
    
    
    func gameOver(){
         if ball.position.y <= positionGameOver || timerCount == 0 {
            self.gameOverFunc()
         }else{
        positionGameOver = ball.position.y
        }
        ball.run(SKAction.wait(forDuration: 5.5)) {
            if self.isGameOver == false && self.gameRunning == true {
                self.gameOver()
            }
    }
    
    }
   
    func gameOverFunc(){

//abaxaqui

            
            scoreLabel.text = "\(score)"
           
            isGameOver = true
            gameRunning = false
       
        
        
            if timerCount == 0 {
                 continueLabel.text = "YOU ARE OUT OF TIME!"
            }else if ball.position.y < positionGameOver - (view?.frame.height)! {
             continueLabel.text = "GAME OVER"
            }else if ball.position.y <= positionGameOver {
                 continueLabel.text = "YOU WERE TOO SLOW!"
        }
        
        backgroundMusic.run(SKAction.changeVolume(to: 0.2, duration: 0.5))
        ball.run(SKAction.playSoundFileNamed("timeout", waitForCompletion: false))
            
            ground.removeFromParent()
            resizeBt.removeAllActions()
            removerBt.removeAllActions()
            
            //codígo que eeeeeu criei sozinho heehehe serve para remover nodes pela categoria física
            //sou um genio
            let children = scene?.children
            for child in children! {
                if child.physicsBody != nil {
   if  child.physicsBody?.categoryBitMask == PhysicsCategory.obstacleCategory || child.physicsBody?.categoryBitMask == PhysicsCategory.clockCategory || child.physicsBody?.categoryBitMask == PhysicsCategory.pipeCategory || child.physicsBody?.categoryBitMask == PhysicsCategory.gigaCategory {
                          child.removeFromParent()
                    }
                }
            }
         
            ball.physicsBody?.isDynamic = false
 ball.alpha = 0
            
            //Verifica o score e o highscore para caso haja um novo recorde, este seja computado e salvo
            if score>bestScore {
                bestScore = score
                //Salva o highscore, caso haja.
                UserDefaults.standard.set(bestScore, forKey: "bestscoreSaved")
                UserDefaults.standard.synchronize()
            bestScoreLabel.text = "BEST: \(bestScore)"
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploadGameCenterObserver"), object: nil)
                
            }
            let colorBallNode = SKSpriteNode(imageNamed: "colors")
            colorBallNode.size = CGSize(width: (view?.frame.width)!*0.2, height: (view?.frame.width)!*0.2)
            colorBallNode.zPosition = 99
            colorBallNode.alpha = 0
            colorBallNode.position = CGPoint(x: -colorBallNode.frame.width*0.5, y: -(view?.frame.height)!*0.04)
            myCamera.addChild(colorBallNode)
            
            let colorsLabel = SKLabelNode(fontNamed: "Cabana")
            colorsLabel.zPosition = 99
            colorsLabel.fontColor = UIColor.black
            colorsLabel.fontSize = 45
            colorsLabel.alpha = 0
            myCamera.addChild(colorsLabel)
            
            
            //Salva o novo número de colorBalls
            if adsMustLoad == true{
                colorBalls += score
                 colorsLabel.text = "+\(score)"
                UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
                UserDefaults.standard.synchronize()
                restartLabel.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.1-continueAd.frame.height-restartLabel.frame.height*3.5)
                 restartLabel.run(SKAction.fadeIn(withDuration: 0.5))
                if UIDevice.current.userInterfaceIdiom == .pad {
                    restartLabel.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.14-continueAd.frame.height-restartLabel.frame.height*3.5)
                       if UIDevice.current.userInterfaceIdiom == .pad {
                         restartLabel.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.17-continueAd.frame.height-restartLabel.frame.height*3.5)
                    }
                }else{
                    restartLabel.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.1-continueAd.frame.height-restartLabel.frame.height*3.5)
                       if UIDevice.current.userInterfaceIdiom == .pad {
                        restartLabel.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.11-continueAd.frame.height-restartLabel.frame.height*3.5)
                    }
                }
            }else if adsMustLoad == false{
                continueAd.texture = SKTexture(imageNamed: "continueNoAds")
                restartLabel.alpha = 0
                restartLabel.position  = CGPoint(x: -(view?.frame.width)!, y: 0)
                colorBalls += score*2
                  colorsLabel.text = "+\(score*2)"
                UserDefaults.standard.set(colorBalls, forKey: "colorBallsSaved")
                UserDefaults.standard.synchronize()
            }
            
             colorsLabel.position = CGPoint(x: colorsLabel.frame.width, y: -(view?.frame.height)!*0.04-colorsLabel.frame.height*0.5)
            //Para todas as ações de geração:
            f1 = false
            f2 = false
            f3 = false
  
            //Coloca os elementos de volta
            //TEM QUE COLOCAR NA CAMERA NAO NA CENA!!!!
            continueLabel.position = CGPoint(x: 0, y:  myCamera.position.y+(view?.frame.height)!*0.37-continueLabel.frame.height)
            continueAd.position = CGPoint(x: 0, y: myCamera.position.y-(view?.frame.height)!*0.15-continueAd.frame.height)
            scoreLabel.fontSize = 120
            scoreLabel.run(SKAction.moveBy(x: 0, y: -scoreLabel.frame.height, duration: 0))
            continueAd.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.1, duration: 1), SKAction.scale(to: 1.0, duration: 1)])))
            bestScoreLabel.removeFromParent()
            myCamera.addChild(bestScoreLabel)
            bestScoreLabel.position = CGPoint(x: 0, y: scoreLabel.position.y-scoreLabel.frame.height-bestScoreLabel.frame.height*1.5)
            bestScoreLabel.fontColor = UIColor.white
            bestScoreLabel.run(SKAction.fadeIn(withDuration: 0.5))
            
            
        if (view?.bounds.height)! != 812.0{
            if (view?.bounds.width)! == 375.0{
                colorBallNode.position = CGPoint(x: -colorBallNode.frame.width*0.5, y: -(view?.frame.height)!*0.12)
                 colorsLabel.position = CGPoint(x: colorsLabel.frame.width, y: -(view?.frame.height)!*0.12-colorsLabel.frame.height*0.5)
            }else if (view?.bounds.width)! == 320.0{
                scoreLabel.run(SKAction.moveBy(x: 0, y: +scoreLabel.frame.height/2, duration: 0))
                bestScoreLabel.position = CGPoint(x: 0, y: scoreLabel.position.y-scoreLabel.frame.height/2-bestScoreLabel.frame.height*1.5)
                colorBallNode.position = CGPoint(x: -colorBallNode.frame.width*0.5, y: -(view?.frame.height)!*0.15)
                colorsLabel.position = CGPoint(x: colorsLabel.frame.width, y: -(view?.frame.height)!*0.15-colorsLabel.frame.height*0.5)
            }else if (view?.bounds.width)! == 414.0{
                scoreLabel.run(SKAction.moveBy(x: 0, y: +scoreLabel.frame.height*0.3, duration: 0))
                bestScoreLabel.position = CGPoint(x: 0, y: scoreLabel.position.y-scoreLabel.frame.height*0.65-bestScoreLabel.frame.height*1.5)
                colorBallNode.position = CGPoint(x: -colorBallNode.frame.width*0.5, y: -(view?.frame.height)!*0.07)
                colorsLabel.position = CGPoint(x: colorsLabel.frame.width, y: -(view?.frame.height)!*0.07-colorsLabel.frame.height*0.5)
                
            }
        }
        
          if UIDevice.current.userInterfaceIdiom == .pad {
            scoreLabel.run(SKAction.moveBy(x: 0, y: +scoreLabel.frame.height*0.3, duration: 0))
            bestScoreLabel.position = CGPoint(x: 0, y: scoreLabel.position.y-scoreLabel.frame.height*0.6-bestScoreLabel.frame.height*1.5)
           
            colorBallNode.position = CGPoint(x: -colorBallNode.frame.width*0.5, y: -(view?.frame.height)!*0.1)
          colorBallNode.setScale(0.7)
            colorsLabel.position = CGPoint(x: colorsLabel.frame.width, y: -(view?.frame.height)!*0.1-colorsLabel.frame.height*0.5)
        }
   
            
            
            colorsLabel.run(SKAction.fadeIn(withDuration: 0.5))
            colorBallNode.run(SKAction.fadeIn(withDuration: 0.5))
            removerBt.run(SKAction.fadeOut(withDuration: 0.2))
            resizeBt.run(SKAction.fadeOut(withDuration: 0.2))
            continueLabel.run(SKAction.fadeIn(withDuration: 0.5))
            continueAd.run(SKAction.fadeIn(withDuration: 0.5))
            timerLabel.run(SKAction.fadeOut(withDuration: 0.2))
            removerBt.run(SKAction.fadeOut(withDuration: 0.2))
            resizeBt.run(SKAction.fadeOut(withDuration: 0.2))
            deleterNumberLabel.run(SKAction.fadeOut(withDuration: 0.2))
            resizeNumberLabel.run(SKAction.fadeOut(withDuration: 0.2))
            
          
            
        }
        
    
    
    
    
    
    
    
    



    override func update(_ currentTime: TimeInterval) {
        
    
    

 //myCamera.position.y = ball.position.y
        let deltaTime = currentTime - lastUpdateTime
        currentFPS = CGFloat(1 / deltaTime)
        lastUpdateTime = currentTime

        if gameRunning == true {
            //57
        if currentFPS < 1 {
            scene?.physicsWorld.speed = 0
        }else{
            scene?.physicsWorld.speed = 0.99
        }
        }
        if gameRunning == true && ball.position.y>(view?.frame.height)!/2 {
            if canScore == true {
            let newScore = (Int(ball.position.y)-initial)/100
                if newScore > score {
                    score = newScore
                }
            }
        camera?.position.y = ball.position.y
            wallLeft.position.y = ball.position.y
            wallRight.position.y = ball.position.y
            deleter.position = CGPoint(x: 0, y: ball.position.y - (view?.frame.height)!)
           
        }
    }
}
    


