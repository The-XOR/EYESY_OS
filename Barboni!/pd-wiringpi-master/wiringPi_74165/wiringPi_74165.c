#include "m_pd.h"
#include <wiringPi.h>
#include <unistd.h>

static t_class *wiringPi_74165_class;

typedef struct _wiringPi_74165
{
    t_object x_obj;
    t_outlet *x_out1;
    int CP, PL, DATA;
} t_wiringPi_74165;

static int stable_read(int pin)
{
    int value1 = digitalRead(pin);
    usleep(500);
    int value2 = digitalRead(pin);
    return value1 == value2 ? value1 : 0;  // If mismatch, assume low
}

static void wiringPi_74165_bang(t_wiringPi_74165 *x)
{
    digitalWrite (x->PL, LOW);
    usleep(1000);
    digitalWrite (x->PL, HIGH);

    int data = 0;
    for(int k=0; k<16;k++)
    {
        int bit = stable_read(x->DATA);
        data = (data << 1) | bit ;
        digitalWrite(x->CP, HIGH);
        usleep(1000);
        digitalWrite(x->CP, LOW);
        usleep(1000);
    }
   	outlet_float(x->x_out1, data);
}

static void *wiringPi_74165_new(t_floatarg f1, t_floatarg f2, t_floatarg f3) 
{
    t_wiringPi_74165 *x = (t_wiringPi_74165 *)pd_new(wiringPi_74165_class);
    x->x_out1 = outlet_new(&x->x_obj, gensym("float"));
 
	x->PL = f1;     // primo argomento: parallel load pin
    x->CP = f2;     // secondo argomento: clock pin
	x->DATA  = f3;  // terzo argomento: data pin
	
	post("CP:%d, PL:%d, DATA:%d,", x->CP, x->PL, x->DATA); 
	
    if (wiringPiSetup() == -1)
    {
        post("wiringSetup() failed miserably");
        exit (1);
    }

    pinMode (x->CP, OUTPUT);
    digitalWrite (x->CP, LOW);
    pinMode (x->PL, OUTPUT);
    digitalWrite (x->PL, HIGH);
    pinMode (x->DATA, INPUT);
    pullUpDnControl (x->CP, PUD_DOWN);
    return x;
}

void wiringPi_74165_setup(void)
{
    wiringPi_74165_class = class_new(gensym("wiringPi_74165"), 
		(t_newmethod)wiringPi_74165_new, 
		0, sizeof(t_wiringPi_74165), 
		CLASS_DEFAULT, A_DEFFLOAT, A_DEFFLOAT, A_DEFFLOAT, 0);
    class_addbang(wiringPi_74165_class, wiringPi_74165_bang);
    post("wiringPi_74165 version 1.0");
}
