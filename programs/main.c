#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>

int main(){
  //create path to new file
  char * filepath = (char*)malloc(sizeof(char) * 1024);
  getcwd(filepath, 1024);
  char * filename = "/message.txt";
  strncpy(&(filepath[strlen(filepath)]), filename, strlen(filename));
  filepath[strlen(filepath)] = '\0';

  //create file
  int fd = open(filepath, O_CREAT | O_WRONLY, 0700);
  if (fd == -1){
    exit(1);
  }

  //write message
  char * message = "You have been hacked";
  write(fd, message, strlen(message));
  close(fd);
  
  return 0;
}
