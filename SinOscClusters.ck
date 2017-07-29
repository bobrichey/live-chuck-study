public class SinOscClusters
{
    15 => int NUM_VOICES;
    
    SinOsc sin[NUM_VOICES];
    Envelope env[NUM_VOICES];
    Chorus chor[NUM_VOICES];
    Pan2 pan[NUM_VOICES];
    
    0.06 => float minGain;
    0.08 => float maxGain;
    0.02 => float GAIN_INCREMENT;
    
    100 => float minFreq;
    800 => float maxFreq;
    1.5 => float PITCH_INCREMENT;
    
    4000 => float ramptime;   
    0.85 => float DURATION_INCREMENT;
    
    [24, 26, 33, 35, 42, 44, 51] @=> int notes[];
    
    0 => int isOn;
    
    "SinOscClusters" => string className;
    
    for (0 => int i; i < NUM_VOICES; i++)
    {
        sin[i] => chor[i] => env[i] => pan[i] => dac;
        0. => chor[i].mix;
    }
        
    fun void play()
    {
        while (true)
        {
            if (isOn % 2 == 0)
            { 
                break;
            }
            for (0 => int i; i < NUM_VOICES; i++)
            {
                Math.random2f(minGain, maxGain) => sin[i].gain;
                //Std.mtof(notes[Math.random2(0, notes.cap() - 1)] + (12 * Math.random2(3, 5))) => sin[i].freq;
                Math.random2f(minFreq, maxFreq) => sin[i].freq;
                Math.random2f(-1.0, 1.0) => pan[i].pan;
                ramptime::ms => env[i].duration;
                1 => env[i].keyOn;
            }
            ramptime::ms => now;
            
            for (0 => int i; i < NUM_VOICES; i++)
            {
                1 => env[i].keyOff;
            }    
            ramptime::ms => now;
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
        GAIN_INCREMENT +=> minGain;
        GAIN_INCREMENT +=> maxGain;
        if (minGain >= 0.18)
        {
            0.18 => minGain;
        }
        if (maxGain >= 0.2)
        {
            0.2 => maxGain;
        }
        <<< "Increase", className, "gain to:", Std.ftoa(minGain, 2) + "-" + Std.ftoa(maxGain, 2) >>>;
    }
    
    fun void decreaseGain()
    {
        GAIN_INCREMENT -=> minGain;
        GAIN_INCREMENT -=> maxGain;
        if (minGain <= 0)
        {
            0 => minGain;
        }
        if (maxGain <= 0.02)
        {
            0.02 => maxGain;
        }
        <<< "Decrease", className, "gain to:", Std.ftoa(minGain, 2) + "-" + Std.ftoa(maxGain, 2) >>>;
    }
    
    fun void increaseRamptime()
    {
        DURATION_INCREMENT /=> ramptime;
        <<< "Increase", className, "duration to:", Std.ftoa(ramptime * 2, 0), "ms" >>>;
    }
    
    fun void decreaseRamptime()
    {
        DURATION_INCREMENT *=> ramptime;
        if (ramptime <= 50)
        {
            50 => ramptime;
        }
        <<< "Decrease", className, "duration to:", Std.ftoa(ramptime * 2, 0), "ms" >>>;
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
        if (maxFreq <= 400)
        {
            400 => maxFreq;
        }
        <<< "Decrease", className, "pitch to:", Std.ftoa(minFreq, 0) + "-" + Std.ftoa(maxFreq, 0), "Hz" >>>;
    }
}