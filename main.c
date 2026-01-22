#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h> // for getpid()

extern char lfsr_next_char(int charset_type);
extern void lfsr_seed(unsigned int seed);

const char *charsets[] = {
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
    "0123456789",
    "!@#$%^&*()-_=+[]{}",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}"
};

enum {
    CHARSET_ALPHA = 0,
    CHARSET_NUMERIC,
    CHARSET_SYMBOLS,
    CHARSET_ALPHANUM,
    CHARSET_MIXED
};

void print_charset_options() {
    printf("Character set options:\n");
    printf("  0 - Alphabet only\n");
    printf("  1 - Numbers only\n");
    printf("  2 - Symbols only\n");
    printf("  3 - Alphanumeric\n");
    printf("  4 - Mixed (letters, numbers, symbols)\n");
}

int main() {
    int length, set;

    printf("Enter password length: ");
    scanf("%d", &length);
    if (length <= 0 || length > 128) {
        printf("Invalid length.\n");
        return 1;
    }

    print_charset_options();
    printf("Select character set (0-4): ");
    scanf("%d", &set);
    if (set < 0 || set > 4) {
        printf("Invalid character set.\n");
        return 1;
    }

    unsigned int seed = (unsigned int)(time(NULL) ^ getpid() ^ clock());
    lfsr_seed(seed);

    printf("Generated password: ");
    for (int i = 0; i < length; i++) {
        char c = lfsr_next_char(set);
        printf("%c", c);
    }
    printf("\n");

    return 0;
}

