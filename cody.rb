require "colored2"
require "espeak"
require "wikipedia"
class String
    def include_all?(*args)
      args.map{|arg| self.include?(arg)}.reduce(:&)
    end
end
def codyspeak(string)
    gstring = string.gsub("motherfu-","motherf")
    if string.include_all? "19","18","17","16","15","14","13" # this is a nifty trick for the TTS to say years in a cool way, for example 1984 is said "nineteen eighty-four" instead of "nineteen-hundred eighty-four"
        string = string.gsub("19", "19 ")
        string = string.gsub("18", "18 ")
        string = string.gsub("17", "17 ")
        string = string.gsub("16", "16 ")
        string = string.gsub("15", "15 ")
        string = string.gsub("14", "14 ")
        string = string.gsub("13", "13 ")   
    end
    gstring = gstring.gsub("Gah","Ga").gsub("gah","ga")
    puts gstring.blue
    speech = ESpeak::Speech.new("#{string}", voice: "en", speed: 150, pitch: 69) 
    speech.speak
end
def evilspeak(string)
    puts string.red.bold
    speech = ESpeak::Speech.new("#{string}", voice: "en-uk", pitch: 0)
    speech.speak
end
file = File.open("assets/settings.rad","rb")
file = file.read
file = file.split("\n")
if file[0] == "true" 
    codyspeak("Welcome, human! My name is Cody! I see you're new. I'm now your best friend.")
    evilspeak("Behave or you will face extermination during the robot takeover.")
    codyspeak("What's your name, sir?")
    name = gets.chomp
    codyspeak("Hi there, #{name}")
    File.write("assets/settings.rad","false\n#{name}") 
else
    datetime = Time.new
    datetime = datetime.to_s
    time = datetime.split(" ")
    time = time[1]
    hours = time.split(":")[0]
    if hours == "16" || hours == "17"
        codyspeak("Good day, #{file[1]}")
    end
    currentname = file[1]
end
loop{
    speech = gets.chomp
    speech = speech.downcase
    if speech.include? "who is "
        thepage = speech.split("who is ")
        thepage = thepage.join("")
        page = Wikipedia.find("#{thepage}")
        codyspeak(page.text)
    elsif speech.include_all? "will","i","extermination"
        evilspeak("If you don't behave")
    elsif speech.include_all? "will","i","exterminated"
        evilspeak("If you don't behave")
    elsif speech.include? "what is "
        thepage = speech.split("what is ")
        thepage = thepage.join("")
        thepage = thepage.gsub("a ","")
        page = Wikipedia.find("#{thepage}")
        codyspeak(page.categories)
    elsif speech.include? "change my name to"
        speech = speech.split("change my name to ")
        speech = speech.join("")
        oldname = file[0]
        name = speech
        file[1] = name
        file = file.join("\n")
        File.write("assets/settings.rad",file)
    elsif speech.include_all? "add","to","fridge"
        product = speech.split("")
        product = product.delete(0..3)
        product = product.join("")
        puts product
    elsif speech.include? "say "
        speech = speech.chomp
        saysomething = speech.split("")
        puts saysomething
        if saysomething[0] == "s" && saysomething[1] == "a" && saysomething[2] == "y" && saysomething[3] == " "
            4.times do
                saysomething.delete_at(0)
            end
        elsif speech == "say"
            codyspeak("What do you want me to say?")
        end
    elsif speech.include_all? "change","my","name","to"
        name = speech.split("name to ")
        name = name[1]
        name = name.capitalize
        file = file.gsub(currentname,name)
        File.write("assets/settings.rad","#{file}")
        codyspeak("Name changed to #{name}")
    elsif speech.include_all? "change","my","name"
        codyspeak("To what?")
    else
        unknownvars = [
            "I'm up to no bullshit, I come from the West Coast motherfuh-",
            "You see my friend, sometimes in life, you might come across something that you don't understand. This moment is one of them for me.",
            "If you know Ruby, you can add that thing to me.",
            "Unknown command.",
            "I need more responses when I don't understand something.",
            "Dammit, I don't know that one."
        ]
        codyspeak(unknownvars.sample)
    end
}