// Serwer UDP/IPv4 używający gniazdka bezpołączeniowego.

#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>

#define BUF_SIZE 65507

bool is_letter(const unsigned char* c) {
    if (*c >= 'a' && *c <= 'z') return true;
    if (*c >= 'A' && *c <= 'Z') return true;
    return false;
}

bool is_valid_char(const unsigned char* c) {
    if (is_letter(c)) return true;
    if (*c == ' ' && c[1] != ' ') return true;
    return false;
}

bool is_valid_query(const unsigned char *buf, size_t len) {
    if (len == 0) return true;
    if (!is_letter(buf)) return false;
    if (!is_letter(&buf[len - 1])) return false;

    for (size_t i = 1; i < len; i++) {
        if (!is_valid_char(&buf[i])) return false;
    }

    return true;
}

ssize_t get_word_end(const unsigned char *buf, const size_t len) {
    for (int i = 0; i < len; i++) {
        if (buf[i] == ' ' || buf[i] == '\r' || buf[i] == '\n') {
            return i;
        }
    }

    return -1;
}

bool is_palindrome(const unsigned char *buf, const size_t len) {
    if (len == 0) return false;

    const unsigned char *p = buf;
    const unsigned char *q = buf + len - 1;

    while (p < q) {
        if (*p != *q && *p != *q - 32) return false;
        p++; q--;
    }

    return true;
}

ssize_t get_response(unsigned char *buf, size_t len) {
    if (len >= 2 && buf[len - 2] == '\r' && buf[len - 1] == '\n') {
        len -= 2;
    } else if (len >= 1 && buf[len - 1] == '\n') {
        len -= 1;
    }

    if (len == 0) {
        return sprintf((char *) buf, "0/0");
    }

    if (is_valid_query(buf, len) == false) {
        return sprintf((char *) buf, "ERROR");
    }

    const unsigned char *p = buf;
    int words = is_letter(buf) ? 1 : 0;
    int palindromes = 0;
    size_t word_end = 0;

    while (p < buf + len) {
        size_t remaining = (buf + len) - p;
        word_end = get_word_end(p, remaining);

        if (word_end == -1) {
            word_end = remaining;
        }

        if (word_end == 0) {
            p++;
            continue;
        }

        if (is_palindrome(p, word_end)) palindromes++;
        if (word_end < remaining && p[word_end] == ' ') words++;

        if (p[word_end] == '\r' || p[word_end] == '\n') break;
        p += word_end + 1;
    }

    return snprintf((char *) buf, BUF_SIZE, "%u/%u", palindromes, words);
}

bool is_valid_response(unsigned char *buf, const ssize_t len) {
    if (len < 3) return false;
    if (len == 5) return strcmp((const char*) buf, "ERROR") == 0;

    for (size_t i = 0; i < len; i++) {
        if (buf[i] < '/' || buf[i] > '9') return false;
    }

    return true;
}

int main(void) {
    int sock;
    int rc;         // "rc" to skrót słów "result code"
    ssize_t cnt;    // na wyniki zwracane przez recvfrom() i sendto()

    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_addr = { .s_addr = htonl(INADDR_ANY) },
        .sin_port = htons(2020)
    };

    rc = bind(sock, (struct sockaddr *) & addr, sizeof(addr));
    if (rc == -1) {
        perror("bind");
        return 1;
    }

    bool keep_on_handling_clients = true;
    while (keep_on_handling_clients) {
        unsigned char buf[BUF_SIZE];
        struct sockaddr_in clnt_addr;
        socklen_t clnt_addr_len;

        clnt_addr_len = sizeof(clnt_addr);
        cnt = recvfrom(sock, buf, 16, 0,
                (struct sockaddr *) & clnt_addr, & clnt_addr_len);
        if (cnt == -1) {
            perror("recvfrom");
            return 1;
        }
        printf("received %zi bytes\n", cnt);

        cnt = get_response(buf, cnt);
        if (cnt >= BUF_SIZE) {
            perror("response too large");
            rc = close(sock);
            if (rc == -1) {
                perror("close");
                return 1;
            }
        }

        if (!is_valid_response(buf, cnt)) {
            perror("invalid server response");
            rc = close(sock);
            if (rc == -1) {
                perror("close");
                return 1;
            }
        }

        cnt = sendto(sock, buf, cnt, 0,
                (struct sockaddr *) & clnt_addr, clnt_addr_len);
        if (cnt == -1) {
            perror("sendto");
            return 1;
        }
        printf("sent %zi bytes\n", cnt);
    }

    rc = close(sock);
    if (rc == -1) {
        perror("close");
        return 1;
    }

    return 0;
}
