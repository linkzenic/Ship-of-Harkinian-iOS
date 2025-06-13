#pragma once

#include <libultraship/libultra/types.h>
#include "item-tables/ItemTableTypes.h"

typedef struct EnemyEntry {
    int16_t id;
    int16_t params;
} EnemyEntry;

#define RANDOMIZED_ENEMY_SPAWN_TABLE_SIZE 52

bool IsEnemyFoundToRandomize(int16_t sceneNum, int8_t roomNum, int16_t actorId, int16_t params, float posX);
bool IsEnemyAllowedToSpawn(int16_t sceneNum, int8_t roomNum, EnemyEntry enemy);
EnemyEntry GetRandomizedEnemyEntry(uint32_t seed, PlayState* play);

extern const char* enemyCVarList[];
extern const char* enemyNameList[];
extern void GetSelectedEnemies();

#ifndef __cplusplus
struct PlayState;

uint8_t GetRandomizedEnemy(struct PlayState* play, int16_t* actorId, f32* posX, f32* posY, f32* posZ, int16_t* rotX,
                           int16_t* rotY, int16_t* rotZ, int16_t* params);
#endif
