<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

     $active_group = 'default';
     $active_record = FALSE;
     $db['default']['hostname'] = getenv('DB_HOST') ?: '';
     $db['default']['username'] = getenv('DB_USERNAME') ?: '';
     $db['default']['password'] = getenv('DB_PASSWORD') ?: '';
     $db['default']['database'] = getenv('DB_NAME') ?: '';
     $db['default']['port']     = getenv('DB_PORT') ?: 3306;
     $db['default']['dbdriver'] = 'mysqli';
     $db['default']['dbprefix'] = '';
     $db['default']['pconnect'] = getenv('DB_PERSISTENT') ? TRUE : FALSE;
     $db['default']['db_debug'] = defined('ENVIRONMENT') && ENVIRONMENT !== 'production';
     $db['default']['cache_on'] = getenv('DB_CACHE') ? TRUE : FALSE;
     $db['default']['cachedir'] = '';
     $db['default']['char_set'] = 'utf8';
     $db['default']['dbcollat'] = 'utf8_general_ci';
     $db['default']['swap_pre'] = '';
     $db['default']['autoinit'] = TRUE;
     $db['default']['stricton'] = FALSE;
    $dbSaveQueriesEnv = getenv('DB_SAVE_QUERIES');
    $db['default']['save_queries'] = $dbSaveQueriesEnv === FALSE
        ? TRUE
        : (filter_var($dbSaveQueriesEnv, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? TRUE);
