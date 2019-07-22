# Test repository to show an issue with sidekiq-unique-jobs gem (6.0.13)

## Steps

Install gems:
```
bundle install
```


Run rails console:
```
bundle exec rails c

# in the console:
HardWorker.perform_async
```


Run sidekiq:
```
bundle exec sidekiq

# in the log:

The signal USR1 is in use by the JVM and will not work correctly on this platform
2019-07-22T18:25:15.789Z 22522 TID-1jw INFO: Running in jruby 9.1.17.0 (2.3.3) 2018-04-20 d8b1ff9 Java HotSpot(TM) 64-Bit Server VM 25.172-b11 on 1.8.0_172-b11 +jit [darwin-x86_64]
2019-07-22T18:25:15.796Z 22522 TID-1jw INFO: Sidekiq Pro 3.7.1, commercially licensed.  Thanks for your support!
2019-07-22T18:25:15.798Z 22522 TID-1jw INFO: Booting Sidekiq 4.2.10 with redis options {:url=>nil}
2019-07-22T18:25:15.910Z 22522 TID-1jw INFO: Starting processing, hit Ctrl-C to stop
2019-07-22T18:25:29.336Z 22522 TID-1k6 HardWorker JID-d77c1092abf2dbf703c525c4 INFO: start
2019-07-22T18:25:29.357Z 22522 TID-1k6 HardWorker JID-d77c1092abf2dbf703c525c4 INFO: done: 0.018 sec
2019-07-22T18:25:36.766Z 22522 TID-1k8 HardWorker JID-a781ab22c477f9f97708b5ce INFO: start
"Hello, world!"
2019-07-22T18:25:38.811Z 22522 TID-1k8 HardWorker JID-a781ab22c477f9f97708b5ce INFO: fail: 2.051 sec
2019-07-22T18:25:38.815Z 22522 TID-1k8 WARN: {"context":"Job raised exception","job":{"class":"HardWorker","args":[],"retry":true,"queue":"default","unique":"until_and_while_executing","jid":"a781ab22c477f9f97708b5ce","created_at":1563819936.645598,"lock_timeout":0,"lock_expiration":null,"unique_prefix":"uniquejobs","unique_args":[],"unique_digest":"uniquejobs:0966e3da8504afbb5fc401b413cb1b7d:RUN","enqueued_at":1563819936.741689,"error_message":"BOOM!","error_class":"RuntimeError","failed_at":1563819938.812271,"retry_count":0},"jobstr":"{\"class\":\"HardWorker\",\"args\":[],\"retry\":true,\"queue\":\"default\",\"unique\":\"until_and_while_executing\",\"jid\":\"a781ab22c477f9f97708b5ce\",\"created_at\":1563819936.645598,\"lock_timeout\":0,\"lock_expiration\":null,\"unique_prefix\":\"uniquejobs\",\"unique_args\":[],\"unique_digest\":\"uniquejobs:0966e3da8504afbb5fc401b413cb1b7d\",\"enqueued_at\":1563819936.741689}"}
2019-07-22T18:25:38.815Z 22522 TID-1k8 WARN: RuntimeError: BOOM!
...
... ERROR TRACE HERE...
...
2019-07-22T18:26:22.207Z 22522 TID-1k6 HardWorker JID-a781ab22c477f9f97708b5ce INFO: start
2019-07-22T18:26:22.211Z 22522 TID-1k6 HardWorker JID-a781ab22c477f9f97708b5ce INFO: done: 0.004 sec
```

It starts and finishes with "done" without real execution.
It will retry when:
- use `gem 'sidekiq-unique-jobs', '~> 4.0.17'`
or
- don't use `Sidekiq.configure_server { |config| config.reliable_scheduler! }`
