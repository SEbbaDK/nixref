#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>

#define BUFSIZE 10000

#define STATE_OUTSIDE 0
#define STATE_MULTILINE_BEFORE 1
#define STATE_MULTILINE 2
#define STATE_MULTILINE_AFTER 3
#define STATE_READING_NAME 4

typedef struct {
    int count;
    int state;
    char content[BUFSIZE];
    size_t content_len;
    size_t name_len;
    char name[BUFSIZE];
} context_t;

inline bool allowed_iden_char(char c) {
    return isalpha(c) || (c == '\'');
}

void parse_char(context_t *ctx, char c) {
    switch (ctx->state) {
        case STATE_OUTSIDE:
            switch (c) {
                case '/':
                    ctx->state = STATE_MULTILINE_BEFORE;
                    break;
            }
            break;

        case STATE_MULTILINE_BEFORE:
            if (c == '*') {
                ctx->state = STATE_MULTILINE;
            } else {
                ctx->state = STATE_OUTSIDE;
            }
            break;

        case STATE_MULTILINE:
            switch (c) {
                case '*':
                    ctx->state = STATE_MULTILINE_AFTER;
                    break;
                case '\n':
                    // JESUS CHRIST
                    ctx->content[ctx->content_len++] = '\\';
                    ctx->content[ctx->content_len++] = 'n';
                    break;
                case '"':
                    ctx->content[ctx->content_len++] = '\\';
                    ctx->content[ctx->content_len++] = '"';
                    break;
                case '\\':
                    ctx->content[ctx->content_len++] = '\\';
                    ctx->content[ctx->content_len++] = '\\';
                    break;
                default:
                    // Screw you unicode
                    if (c >= 10 && c <= 127) {
                        ctx->content[ctx->content_len++] = c;
                    }
                    break;
            }
            break;

        case STATE_MULTILINE_AFTER:
            if (c == '/') {
                ctx->content[ctx->content_len] = '\0';
                ctx->state = STATE_READING_NAME;
            } else {
                ctx->state = STATE_MULTILINE;
            }
            break;

        case STATE_READING_NAME:
            if (isspace(c)) {
                break;
            } else if (c == '=') {
                ctx->name[ctx->name_len] = '\0';
                if (ctx->count) {
                    printf(",");
                }
                printf("\n  \"%s\": \"%s\"\n", ctx->name, ctx->content);
                ctx->count++;
                ctx->name_len = 0;
                ctx->content_len = 0;
                ctx->state = STATE_OUTSIDE;
                break;
            }
            if (!allowed_iden_char(c)) {
                ctx->name_len = 0;
                ctx->state = STATE_OUTSIDE;
                break;
            }
            ctx->name[ctx->name_len++] = c;
            break;
    }
}

int main() {
    context_t ctx = { count: 0, state: 0, content_len: 0, name_len: 0 };

    printf("{");
    char c;
    while ((c = getchar()) != EOF) {
        parse_char(&ctx, c);
    }
    printf("}");
    return 0;
}
