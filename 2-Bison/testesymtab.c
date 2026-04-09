#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "symtab.h" // Substitua pelo nome do seu header

void test_create_and_insert() {
    printf("Testando inserção básica... ");
    symtab *table = symtab_create();
    assert(table != NULL);

    // Inserção de novo elemento
    symtab_entry *s1 = symtab_insert(table, "variavel_1");
    assert(s1 != NULL);
    assert(strcmp(s1->key, "variavel_1") == 0);
    assert(s1->defined == 0);
    assert(s1->value == 0);

    // Recuperação de elemento existente (não deve duplicar)
    symtab_entry *s2 = symtab_insert(table, "variavel_1");
    assert(s1 == s2); // Devem apontar para o mesmo endereço de memória

    symtab_destroy(table);
    printf("Passou!\n");
}

void test_persistence_and_updates() {
    printf("Testando persistência e atualizações... ");
    symtab *table = symtab_create();

    symtab_entry *s = symtab_insert(table, "x");
    s->defined = 1;
    s->value = 42;

    // Recupera novamente para ver se os valores persistem
    symtab_entry *retrieved = symtab_insert(table, "x");
    assert(retrieved->defined == 1);
    assert(retrieved->value == 42);

    symtab_destroy(table);
    printf("Passou!\n");
}

void test_collisions() {
    printf("Testando colisões (encadeamento externo)... ");
    symtab *table = symtab_create();

    // Inserindo várias chaves para forçar o uso de diferentes buckets 
    // ou colisões dependendo do tamanho definido no seu #define
    symtab_insert(table, "a");
    symtab_insert(table, "b");
    symtab_insert(table, "c");
    symtab_insert(table, "d");

    symtab_entry *s_a = symtab_insert(table, "a");
    assert(s_a != NULL && strcmp(s_a->key, "a") == 0);

    // Se o encadeamento estiver errado, "b" poderia sobrescrever "a"
    symtab_entry *s_b = symtab_insert(table, "b");
    assert(strcmp(s_a->key, "a") == 0); 
    assert(s_a != s_b);

    symtab_destroy(table);
    printf("Passou!\n");
}

void test_large_input() {
    printf("Testando grande volume de dados... ");
    symtab *table = symtab_create();
    char key[20];

    for (int i = 0; i < 1000; i++) {
        sprintf(key, "key_%d", i);
        symtab_entry *s = symtab_insert(table, key);
        s->value = i;
    }

    // Verifica se os valores estão corretos e não houve corrupção
    for (int i = 0; i < 1000; i++) {
        sprintf(key, "key_%d", i);
        symtab_entry *s = symtab_insert(table, key);
        assert(s->value == i);
    }

    symtab_destroy(table);
    printf("Passou!\n");
}

int main() {
    printf("=== Iniciando Testes da Tabela de Símbolos ===\n");
    
    test_create_and_insert();
    test_persistence_and_updates();
    test_collisions();
    test_large_input();

    printf("=== Todos os testes passaram com sucesso! ===\n");
    return 0;
}