# Difference between "source", ".", "sh", "bash", "./"
If there is a sub-script inside the main script:  
1. Copy code to the main shell:  
"source" == "."  

2. Call sub-shell to execute:  
"sh" == "bash"  
"./" need the file to be executable (+x)  

# BASH_SOURCE
BASH_SOURCE is the input array.  
## ${BASH_SOURCE[0]} vs. $BASH_SOURCE vs. $0
1. __$BASH_SOURCE__ is more recommended.  
2. $0 is not correct when using "source".  
