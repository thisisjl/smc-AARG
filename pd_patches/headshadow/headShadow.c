/***************************************************/
/* External that computes the Head Shadow for the  */
/* HTRF model based on the "An efficient HRTF model*/
/* for 3-D sound" paper of Brown, C. Phillip, and  */
/* Richard O. Duda 								   */
/**************************************************/

#include "m_pd.h"
#include <math.h>
#define RHEAD 0.0875
 

typedef struct headShadowctl				
{
	t_sample c_x;								
	t_sample c_coef;
} t_headShadowctl;
 
 
 /*Struct with all the variables and coefficients 
 that will be used in the computation of the output*/
typedef struct headShadow	/*Data space*/
{
	t_object x_obj;
	t_float x_sr;
	t_float x_hz;
	t_headShadowctl x_cspace;
	t_headShadowctl *x_ctl;
	t_float x_f;
	t_float x_a0;
	t_float x_a1;
	t_float x_b0l;
	t_float x_b0r;
	t_float x_b1l;
	t_float x_b1r;
	t_float inm1;
	t_float lastL;
	t_float lastR;
} t_headShadow;

t_class *headShadow_class;			

static void headShadow_ft1(t_headShadow *x, t_floatarg theta);			
 
static void *headShadow_new(t_floatarg theta)
{
	/* Constructor */
	t_headShadow *x = (t_headShadow *)pd_new(headShadow_class);
	/* Create an inlet for the float argument (in our case the theta for the azimuth angle)*/
	inlet_new(&x->x_obj, &x->x_obj.ob_pd, gensym("float"), gensym("ft1"));
	/* Create two outlets for the signal (l and r) */
	outlet_new(&x->x_obj, &s_signal);
	outlet_new(&x->x_obj, &s_signal);
	x->x_sr = 44100;
	x->x_ctl = &x->x_cspace;								
	x->x_cspace.c_x = 0;
	headShadow_ft1(x, theta);
	x->x_f = 0;
	x->inm1 = 0;
	x->lastL = 0;
	x->lastR = 0;
	return (x);
}

 /* Compute all the filter coefficients*/
static void headShadow_ft1(t_headShadow *x, t_floatarg theta)
{
	t_float t=1/x->x_sr;
	t_float tbeta = t*2*340/RHEAD;
	t_float alphaL=1-sin(theta);
	t_float alphaR=1+sin(theta);
	x->x_a0=2+tbeta;											
	x->x_a1=-2+tbeta;
	x->x_b0l=2*alphaL+tbeta; 								
	x->x_b1l=-2*alphaL+tbeta;
	x->x_b0r=2*alphaR+tbeta;
	x->x_b1r=-2*alphaR+tbeta;
}
 /* Destructor */
static void headShadow_clear(t_headShadow *x, t_floatarg q)
{
	x->x_cspace.c_x = 0;
}
 
 /* Perform of the filter itself. It returns a pointer to a integer 
 A pointer to an integer-array is passed to it. This array contains the
 pointers, that were passed via dsp_add */
 
static t_int *headShadow_perform(t_int *w)
{
	t_headShadow *x = (t_headShadow *)(w[1]);
	t_sample *in = (t_sample *)(w[2]);			
	t_sample *outL = (t_sample *)(w[3]);
	t_sample *outR = (t_sample *)(w[4]);
	t_headShadowctl *c = (t_headShadowctl *)(w[5]);
	int n = (t_int)(w[6]);									
	int i;
	t_sample lastL = c->c_x;
	t_sample lastR = c->c_x;
	t_sample coef = c->c_coef;
	t_float b0l = x->x_b0l;
	t_float b1l = x->x_b1l;
	t_float b0r = x->x_b0r;
	t_float b1r = x->x_b1r;
	t_float a0 = x->x_a0;
	t_float a1 = x->x_a1;
	
	for (i = 0; i < n; i++) {
        x->lastL  = (1/a0) * ((b0l * in[i]) + (b1l * x->inm1) - (a1 * x->lastL));
		x->lastR  = (1/a0) * ((b0r * in[i]) + (b1r * x->inm1) - (a1 * x->lastR));
		/* Updating*/
		x->inm1 = in[i];
		outL[i] = x->lastL;
		outR[i] = x->lastR;
	}
	
	if (PD_BIGORSMALL(lastL)) lastL = 0; c->c_x = lastL;
	if (PD_BIGORSMALL(lastR)) lastR = 0; c->c_x = lastR;
	return (w+7);
}
 
 /* headShadow_dsp adds a perform-routine to the DSP-tree. The first
 argument is the pointer to the class-data space and a pointer to an
 array of signals() */
static void headShadow_dsp(t_headShadow *x, t_signal **sp)
{
	x->x_sr = sp[0]->s_sr;								
	headShadow_ft1(x, x->x_hz);
	dsp_add(headShadow_perform, 6, x,
	sp[0]->s_vec, sp[1]->s_vec, sp[2]->s_vec,
	x->x_ctl, sp[0]->s_n);
}

/* Creates the classes, the object.*/ 
void headShadow_setup(void)
{
	headShadow_class = class_new(gensym("headShadow"), (t_newmethod)headShadow_new, 0,
	sizeof(t_headShadow), 0, A_DEFFLOAT, 0);
	CLASS_MAINSIGNALIN(headShadow_class, t_headShadow, x_f);
	class_addmethod(headShadow_class, (t_method)headShadow_dsp,
	gensym("dsp"), A_CANT, 0);
	class_addmethod(headShadow_class, (t_method)headShadow_ft1,
	gensym("ft1"), A_FLOAT, 0);
	class_addmethod(headShadow_class, (t_method)headShadow_clear, gensym("clear"), 0);
}