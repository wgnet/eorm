-module(eorm_select_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile([export_all]).

all() -> [
    select_limit_offset_order_by_test
    ,select_where_in_test
    ,select_where_any_test
    ,select_where_greater_test
    ,select_group_by_test
    ,select_belongs_to_test
    ,select_relates_has_many_test
].

init_per_suite(Config) ->
    test_utils:init_per_suite(Config).


end_per_suite(Config) ->
    test_utils:end_per_suite(Config).


select_limit_offset_order_by_test(_Config) ->
    Query = #{
        order_by => {id, desc},
        limit => 2,
        offset => 2
    },
    {ok, SQL} = eorm_db:select(user, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(user, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    [3,2] = lists:map(fun eorm_object:id/1, Objs),
    ok.

select_where_in_test(_Config) ->
    Query = #{
        order_by => {id, desc},
        where => #{
            {id, in} => [2,4]
        },
        order_by => id
    },
    {ok, SQL} = eorm_db:select(user, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(user, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    [2,4] = lists:map(fun eorm_object:id/1, Objs),
    ok.

select_where_greater_test(_Config) ->
    Query = #{
        order_by => {id, desc},
        where => #{
            {id, '>'} => 4
        },
        order_by => id
    },
    {ok, SQL} = eorm_db:select(user, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(user, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    [5] = lists:map(fun eorm_object:id/1, Objs),
    ok.

select_where_any_test(_Config) ->
    Query = #{
        order_by => {id, desc},
        where => #{
            {id, any} => [2,4]
        },
        order_by => id
    },
    {ok, SQL} = eorm_db:select(user, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(user, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    [2,4] = lists:map(fun eorm_object:id/1, Objs),
    ok.

select_group_by_test(_Config) ->
    Query = #{
        fields => [
            likes,
            {sql, <<"count(*)">>}
        ],
        where => #{
            user_id => 1
        },
        group_by => likes
    },
    {ok, SQL} = eorm_db:select(post, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(post, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    ok.

select_belongs_to_test(_Config) ->
    Query = #{
        fields => [
            id, likes, created_at
        ],
        with => [user],
        where => #{
            user_id => 1
        }
    },
    {ok, SQL} = eorm_db:select(post, Query#{as_sql => true}),
    {ok, Objs} = eorm_db:select(post, Query),
    ct:log("SQL: ~p", [SQL]),
    ct:log("Objs: ~p", [Objs]),
    ok.

select_relates_has_many_test(_Config) ->
    {ok, Objs} = eorm_db:select(
        post, #{
            with => [
                post_action_log
            ],
            where => #{
                user_id => 1
            }
        }),
    ct:log("Objs: ~p", [Objs]),
    5 = length(Objs),
    ok.