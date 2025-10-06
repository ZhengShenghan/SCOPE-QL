#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int crackme(char *s, int n)
{
    if (strlen(s) != 13) {
        return 0;
    }
    if (strcmp(s, "hacktheplanet") != 0) {
        return 0;
    }
    if (n != 1337) {
        return 0;
    }
    return 1;
}

int main(int argc, char *argv[])
{
    int result = crackme(argv[1], atoi(argv[2]));
    if (result == 1) {
        puts("good job!");
    } else {
        puts("wrong.");
    }
    return result;
}