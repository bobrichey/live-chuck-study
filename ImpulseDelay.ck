public class ImpulseDelay
{
    Impulse imp => ResonZ rez => Gain input => dac; 
    
    1.0 => float inputGain;
    0.2 => float GAIN_INCREMENT;
    
    50 => int q;
    
    Delay del[3]; 
    
    input => del[0] => dac.left; 
    input => del[1] => dac;
    input => del[2] => dac.right; 
    
    // set up delay lines 
    for (0 => int i; i < 3; i++) 
    {
        del[i] => del[i];
        0.6 => del[i].gain;
        (0.8 + i * 0.3)::second => del[i].max => del[i].delay; 
    }
    
    50 => float minFreq;
    200 => float maxFreq;
    1.5 => float PITCH_INCREMENT;
    
    1200 => int tempo;   
    400 => int TEMPO_INCREMENT;
    
    0 => int isOn;
    
    "ImpulseDelay" => string className;
    
    fun void play()
    { 
        while (true)
        {
            if (isOn % 2 == 0)
            { 
                break;
            }
            q => rez.Q;
            inputGain => input.gain;
            input.gain() * 200 => rez.gain;
            Math.random2f(minFreq, maxFreq) => rez.freq;
            1.0 => imp.next;
            tempo::ms => now; 
        }
    }
    
    fun void turnOn()
    {
        isOn++;
        if (isOn % 2 == 1)
        {
            <<< className+": ON", "" >>>;
            spork ~ play();
        }
        else
        {
            <<< className+": OFF", "" >>>;   
        }
    }
    
    fun string getClassName()
    {
        return className;
    }
    
    fun void increaseGain()
    {
        GAIN_INCREMENT +=> inputGain;
        if (inputGain >= 1.8)
        {
            1.8 => inputGain;
        }
        <<< "Increase", className, "gain to:", Std.ftoa(inputGain, 1) >>>;
    }
    
    fun void decreaseGain()
    {
        GAIN_INCREMENT -=> inputGain;
        if (inputGain <= 0)
        {
            0 => inputGain;
        }
        <<< "Decrease", className, "gain to:", Std.ftoa(inputGain, 1) >>>;
    }
    
    fun void increaseTempo()
    {
        TEMPO_INCREMENT -=> tempo;
        if (tempo <= 100)
        {
            100 => tempo;
        }
        <<< "Increase", className, "tempo to:", tempo, "ms" >>>;
    }
    
    fun void decreaseTempo()
    {
        TEMPO_INCREMENT +=> tempo;
        <<< "Decrease", className, "tempo to:", tempo, "ms" >>>;
    }
    
    fun void increasePitch()
    {
        PITCH_INCREMENT *=> minFreq;
        PITCH_INCREMENT *=> maxFreq;
        <<< "Increase", className, "pitch to:", Std.ftoa(minFreq, 0) + "-" + Std.ftoa(maxFreq, 0), "Hz" >>>;
    }
    
    fun void decreasePitch()
    {
        PITCH_INCREMENT /=> minFreq;
        PITCH_INCREMENT /=> maxFreq;
        if (minFreq <= 50)
        {
            50 => minFreq;
        }
        if (maxFreq <= 200)
        {
            200 => maxFreq;
        }
        <<< "Decrease", className, "pitch to:", Std.ftoa(minFreq, 0) + "-" + Std.ftoa(maxFreq, 0), "Hz" >>>;
    }
}
