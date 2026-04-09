#ifndef SYMTAB_H
#define SYMTAB_H

#define SYMTAB_SIZE 101  // tamanho inicial da tabela

typedef struct symtab_entry {
    char *key;
    int defined;
    int value;
    struct symtab_entry *next;
} symtab_entry;

typedef struct {
    symtab_entry *table[SYMTAB_SIZE];
} symtab;

// Cria a tabela
symtab *symtab_create(void);

// Insere ou retorna existente
symtab_entry *symtab_insert(symtab *st, const char *key);

// Libera memória
void symtab_destroy(symtab *st);

#endif