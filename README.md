This is a set of simulink blocks to simulate wastwater treatament plant, based on the benchmark (BSM1) presented in [1]. In the example I have implemented a reactor of two stages (two blocks), the first one is an anoxic process (KLa=0) and the seccond one simulates an aerate reactor with control of the KLa paramenter. Each bioreactor block implements a ASM1 model. There are two recirculation flows: internal recirculation and  from the settler.  For the settler I have considered a simple model in which the concentration of the non-soluble elements in the recirculation flow is proportional to its concentration in the input flow: settler_coefficient * Xi. The recycling_factor is the fraction of the input flow that is recirculated. For proper operation, the following condition must be met: 1 / recycling_factor> settler_coefficient. A recirculation valve is implemented using a setter with settler_coefficient equal to zero. The component_selector block allows us to select one or more elements in the input flow to view or perform other operations. Before running the simulink model, you must load the input flow data by running the "import_data" script.

Possible improvements, (according to [1]):
-------------------------------------------
-Model of the settler. The model given in [1] is quite complex and it is not clear if the effect of its dynamics is considerable with respect to the dynamics of the reactors.
-Include models of the sensors according to category etc.
-.........



[1] J. Alex et.al. Benchmark Simulation Model no. 1 (BSM1). Dept. of Industrial Electrical Engineering and Automation Lund University. 2008. http://www.benchmarkWWTP.org/ 
