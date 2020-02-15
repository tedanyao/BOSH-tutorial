# Difference between "source", ".", "sh", "bash", "./"
If there is a sub-script inside the main script:  
1. Copy code to the main shell:  
* ```source xxx```, ```. ./xxx```  

2. Call sub-shell to execute:  
* ```sh xxx, bash xxx, ./xxx```   
* "sh" is equal to "bash"  
* "./" need the file to be executable (+x)  


### ./ opens up a new shell
### 'source' execute with current shell
```console
vagrant@Security:~$ cat aa
export PATH=/home/vagrant:$PATH
vagrant@Security:~$ ./aa
vagrant@Security:~$ echo $PATH
/usr/local/sbin:...
vagrant@Security:~$ source ./aa
vagrant@Security:~$ echo $PATH
/home/vagrant:/usr/local/sbin:...
```

# BASH_SOURCE
BASH_SOURCE is the input array.  
## ${BASH_SOURCE[0]} vs. $BASH_SOURCE vs. $0
1. __$BASH_SOURCE__ is more recommended.  
2. $0 is not correct when using "source". $0 returns the name of the process. So if you use "source", it refers to the current bash shell (-bash). And if you use "sh", it refers to the filename correctly because the subshell is created from that file.  

# Dirname
dirname returns the __relative__ file path.  
A common script for getting the file location (without filename) is ```DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"```
