#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

// Função hash (djb2 - simples e eficiente)
static unsigned int hash(const char *key) {
    unsigned int h = 5381;
    int c;

    while ((c = *key++))
        h = ((h << 5) + h) + c; // h * 33 + c

    return h % SYMTAB_SIZE;
}

// Cria a tabela
symtab *symtab_create(void) {
    symtab *st = malloc(sizeof(symtab));
    if (!st) return NULL;

    for (int i = 0; i < SYMTAB_SIZE; i++)
        st->table[i] = NULL;

    return st;
}

// Insere ou retorna existente
symtab_entry *symtab_insert(symtab *st, const char *key) {
    unsigned int index = hash(key);
    symtab_entry *current = st->table[index];

    // Verifica se já existe
    while (current) {
        if (strcmp(current->key, key) == 0)
            return current;
        current = current->next;
    }

    // Cria nova entrada
    symtab_entry *new_entry = malloc(sizeof(symtab_entry));
    if (!new_entry) return NULL;

    new_entry->key = strdup(key);
    new_entry->defined = 0;
    new_entry->value = 0;

    // Insere no início da lista (encadeamento externo)
    new_entry->next = st->table[index];
    st->table[index] = new_entry;

    return new_entry;
}

// Libera memória
void symtab_destroy(symtab *st) {
    for (int i = 0; i < SYMTAB_SIZE; i++) {
        symtab_entry *current = st->table[i];

        while (current) {
            symtab_entry *temp = current;
            current = current->next;

            free(temp->key);
            free(temp);
        }
    }

    free(st);
}
