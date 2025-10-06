#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Custom strcmp implementation
int strcmp(const char *s1, const char *s2)
{
    int r = -1;

    if (s1 == s2)
    {
        // short circuit - same string
        return 0;
    }

    // I don't want to panic with a NULL ptr - we'll fall through and fail w/ -1
    if (s1 != NULL && s2 != NULL)
    {
        // iterate through strings until they don't match or s1 ends (null-term)
        for (; *s1 == *s2; ++s1, ++s2)
        {
            if (*s1 == 0)
            {
                r = 0;
                break;
            }
        }

        // handle case where we didn't break early - set return code.
        if (r != 0)
        {
            r = *(const unsigned char *)s1 - *(const unsigned char *)s2;
        }
    }

    return r;
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s <string1> <string2>\n", argv[0]);
        return 1;
    }

    int result = strcmp(argv[1], argv[2]);
    printf("Result: %d\n", result);

    return 0;
}