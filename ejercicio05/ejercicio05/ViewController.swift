

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate{
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var control: UISlider!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var timeCount: UILabel!
    @IBOutlet weak var volumeNumber: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var titleSong: UILabel!
    @IBOutlet weak var authorSong: UILabel!
    
    var tabla : ListTableViewController?
    var player : AVAudioPlayer!
    var timer : Timer!
    var songList: [String]!
    var coverList: [String]!
    var titleList : [String]!
    var authorList: [String]!
    var indexSong : Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayer(songNumber: indexSong!)
        
        player.play()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSecond), userInfo: nil, repeats: true)
        
        volumeNumber.text = "50"
        cover.layer.cornerRadius = 20
        cover.layer.borderWidth = 3
        cover.layer.borderColor = UIColor.orange.cgColor
        
    }
    
    //Función que controla que al cambiar de la pantalla del reproductor a la de lista la cancion se pare junto con el tiempo
    override func viewDidDisappear(_ animated: Bool) {
        player.stop()
        timer.invalidate()
    }
    
    
    //---FUNCIONES---
    
    //Funcion que reproducira la cancion mediante el index (el index lo recibira de la vista de la tabla)
    func initPlayer(songNumber: Int){
        
        //Se accede a la cancion y a su imagen
        let songSource = NSURL(fileURLWithPath: Bundle.main.path(forResource: songList[songNumber], ofType: "mp3")!)
        
        let coverSource = NSURL(fileURLWithPath: Bundle.main.path(forResource: coverList[songNumber], ofType: "jpg")!)
        
        // Se convierte la url de la imagen en un NSData para poder ser utilizado como datos
        let coverData = NSData(contentsOf: coverSource as URL)
        
        //controlador del reproductor
        do{
            player = try AVAudioPlayer(contentsOf: songSource as URL)
            cover.image = UIImage(data: coverData! as Data)
            player.delegate = self
            titleSong.text = titleList[songNumber]
            authorSong.text = authorList[songNumber]
            control.maximumValue = Float(player.duration)
            player.volume = 0.5
            
        }catch{
            print("Error")
        }
    }
    
    //funcion que se encarga de la cuenta del tiempo de la reproduccion tanto del tiempo transcurrido como del tiempo total
    @objc
    func updateSecond(){
        
        var seconds = 0
        var minutes = 0
        var minutesT = 0
        var secondsT = 0
        
        if let time = player?.currentTime{
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        
        if let time = player?.duration{
            secondsT = Int(time) % 60
            minutesT = (Int(time) / 60) % 60
        }
        
        //Se muestra por mantalla el tiempo transcurrido y el tiempo total con el formato escogido
        timeCount.text = ("\(String(format: "%0.2d:%0.2d", minutes,seconds)) / \(String(format: "%0.2d:%0.2d", minutesT,secondsT))")
        
        //El slider del tiempo se iguala al currentTime de la cancion
        control.value = Float(player.currentTime)
    }
    
    //Funcion que se ocupa de pasar a la siguiente cancion cuando se acaba la reproduccion de la cancion que se esta escuchando
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if indexSong == songList.count - 1{
            
            indexSong = -1
        }
        
        //Cuando la cancion se acaba se le suma uno al index de la cancion para que se reproduzca la siguiente, se cambia la imagen del boton play/pause y se inicia la reproduccion
        indexSong += 1
        initPlayer(songNumber: indexSong)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        self.player.play()
        
    }
    
    //---ACTIONS DE LOS BOTONES---
    
    //Action del boton play/pause
    @IBAction func play(_ sender: Any) {
        
        //Si la reproduccion esta en play, al pulsar se pausa la cancion y se cambia la imagen del boton
        if player.isPlaying{
            
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        }else{
            
            //Si la reproduccion esta en pause, al pulsar la cancion se pone en play y se cambia la imagen del boton
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        }
    }
    
    //Action del boton prev (Ir a la cancion anterior)
    @IBAction func prev(_ sender: Any) {
        
        if indexSong == 0{
            indexSong = songList.count
        }
        
        //Al pulsar se le resta uno al index de la cancion para que se reproduzca posicion anterior del array. La cancion se empieza a reproducir y se cambia la imagen del boton play/pause
        indexSong -= 1
        initPlayer(songNumber: indexSong)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player.play()
        
    }
    
    //Action del boton next (Ir a la cancion siguiente)
    @IBAction func next(_ sender: Any) {
        
        if indexSong == songList.count - 1{
            indexSong = -1
        }
        
        //Al pulsar se le resta uno al index de la cancion para que se reproduzca posicion anterior del array. La cancion se empieza a reproducir y se cambia la imagen del boton play/pause
        indexSong += 1
        initPlayer(songNumber: indexSong)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player.play()
        
    }
    
    //Action del slider que controla el tiempo de reproduccion. Si se pulsa la reproduccion se pausa y se puede arrastrar hasta el tiempo donde se quiera avanzar, al soltar la reproduccion pasa a play
    @IBAction func controlSlider(_ sender: UISlider) {
        
        if player.isPlaying{
            
            player.pause()
            player.currentTime = TimeInterval(sender.value)
            player.play()
            
        }else{
            player.currentTime = TimeInterval(sender.value)
        }
    }
    
    //Action del slider del volumen. Se puede arrastrar el slider para cambiar el volumen de la reproduccion. Este se indica en un label
    @IBAction func volumeSlider(_ sender: UISlider) {
        
        player.volume = sender.value
        volumeNumber.text = String(Int((player.volume) * 100))
        
        //Si se arrastra hasta 0, se modifica la imagen del boton del volumen
        if player.volume == 0{
            volumeButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        }else{
            volumeButton.setImage(UIImage(systemName: "volume.2.fill"), for: .normal)
        }
        
    }
    
    //Acion del boton mute. El volumen de la reproduccion pasa a 0 al momento de pulsar el boton, si se vuelve a pulsar el volumen pasa a 50
    @IBAction func mute(_ sender: UISlider) {
        
        if player.volume > 0{
            player.volume = 0
            volumeButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        }else{
            player.volume = 0.5
            volumeButton.setImage(UIImage(systemName: "volume.2.fill"), for: .normal)
        }
        volumeNumber.text = String(Int((player.volume) * 100))
        volume.value = Float(player.volume)
    }
}


