/*
 * Closed Process Group (Corosync CPG) failover module for Freeswitch
 *
 * Copyright (C) 2010 Voismart SRL
 *
 * Authors: Stefano Bossi <sbossi@voismart.it>
 *
 * Further Contributors:
 * Matteo Brancaleoni <mbrancaleoni@voismart.it> - Original idea
 *
 * This program cannot be modified, distributed or used without
 * specific written permission of the copyright holder.
 *
 * The source code is provided only for evaluation purposes.
 * Any usage or license must be negotiated directly with Voismart Srl.
 *
 * Voismart Srl
 * Via Benigno Crespi 12
 * 20159 Milano - MI
 * ITALY
 *
 * Phone : +39.02.70633354
 *
 */
#ifndef CPG_PROFILE_H
#define CPG_PROFILE_H

#include <switch.h>
#include <corosync/cpg.h>
//#include "mod_cpg.h"

#include "node.h"

typedef enum{
    MASTER,
    BACKUP,
    INIT,
    STANDBY
} profile_state_t;///serve davvero?

typedef struct {
    char name[255];
    char virtual_ip[16];
    int netmask;
    profile_state_t state;
    char device[10];
    char mac[18];
    switch_thread_t *profile_thread;
    short int running;
    cpg_handle_t handle;
    struct cpg_name group_name;
    int members_number;
    int priority;
    uint32_t node_id;
    uint32_t master_id;
    char runtime_uuid[40];
    uint32_t rollback_node_id;
    node_t *node_list;
    size_t member_list_entries;
    switch_bool_t autoload;
    switch_bool_t autorecover;
    switch_bool_t autorollback;
    int rollback_delay;
} profile_t;

profile_t *find_profile_by_name(char *profile_name);


switch_status_t profile_start(profile_t *profile);
switch_status_t profile_stop(profile_t *profile);
switch_status_t profile_send_sql(profile_t *profile, char *sql);
switch_status_t profile_send_state(profile_t *profile);

#endif