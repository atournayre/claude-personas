# Reference des configurations Symfony

Guide de reference rapide pour la configuration des principaux bundles et composants Symfony.

## Framework Bundle

```yaml
# config/packages/framework.yaml
framework:
    secret: '%env(APP_SECRET)%'
    csrf_protection: true
    http_method_override: false
    handle_all_throwables: true

    session:
        handler_id: null
        cookie_secure: auto
        cookie_samesite: lax
        storage_factory_id: session.storage.factory.native

    php_errors:
        log: true

    # Validation
    validation:
        email_validation_mode: html5
        enable_attributes: true

    # Serializer
    serializer:
        enable_attributes: true

    # Assets
    asset_mapper:
        paths:
            - assets/
```

## Security Bundle

```yaml
# config/packages/security.yaml
security:
    password_hashers:
        Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface:
            algorithm: auto  # bcrypt ou argon2id selon disponibilite

    providers:
        app_user_provider:
            entity:
                class: App\Entity\User
                property: email

    firewalls:
        dev:
            pattern: ^/(_(profiler|wdt)|css|images|js)/
            security: false
        main:
            lazy: true
            provider: app_user_provider
            form_login:
                login_path: app_login
                check_path: app_login
                enable_csrf: true
            logout:
                path: app_logout
            remember_me:
                secret: '%kernel.secret%'
                lifetime: 604800  # 1 semaine
            login_throttling:
                max_attempts: 5
                interval: '15 minutes'

    access_control:
        - { path: ^/admin, roles: ROLE_ADMIN }
        - { path: ^/profile, roles: ROLE_USER }

    role_hierarchy:
        ROLE_ADMIN: ROLE_USER
        ROLE_SUPER_ADMIN: [ROLE_ADMIN, ROLE_ALLOWED_TO_SWITCH]
```

## Doctrine Bundle

```yaml
# config/packages/doctrine.yaml
doctrine:
    dbal:
        url: '%env(resolve:DATABASE_URL)%'
        profiling_collect_backtrace: '%kernel.debug%'
        use_savepoints: true

    orm:
        auto_generate_proxy_classes: true
        enable_lazy_ghost_objects: true
        report_fields_where_declared: true
        validate_xml_mapping: true
        naming_strategy: doctrine.orm.naming_strategy.underscore_number_aware
        auto_mapping: true
        mappings:
            App:
                type: attribute
                is_bundle: false
                dir: '%kernel.project_dir%/src/Entity'
                prefix: 'App\Entity'
                alias: App
        controller_resolver:
            auto_mapping: true
```

## Messenger

```yaml
# config/packages/messenger.yaml
framework:
    messenger:
        failure_transport: failed

        transports:
            async:
                dsn: '%env(MESSENGER_TRANSPORT_DSN)%'
                retry_strategy:
                    max_retries: 3
                    delay: 1000
                    multiplier: 2
                    max_delay: 0
            failed:
                dsn: 'doctrine://default?queue_name=failed'

        routing:
            'App\Message\AsyncMessage': async
```

## Mailer

```yaml
# config/packages/mailer.yaml
framework:
    mailer:
        dsn: '%env(MAILER_DSN)%'
        envelope:
            sender: '%env(MAILER_SENDER)%'
        headers:
            From: '%env(MAILER_FROM)%'
```

## Monolog

```yaml
# config/packages/monolog.yaml
monolog:
    channels:
        - deprecation
    handlers:
        main:
            type: stream
            path: '%kernel.logs_dir%/%kernel.environment%.log'
            level: debug
            channels: ['!event']
        console:
            type: console
            process_psr_3_messages: false
            channels: ['!event', '!doctrine', '!console']
        deprecation:
            type: stream
            channels: [deprecation]
            path: '%kernel.logs_dir%/deprecation.log'
```

## Twig

```yaml
# config/packages/twig.yaml
twig:
    file_name_pattern: '*.twig'
    form_themes: ['bootstrap_5_layout.html.twig']
    globals:
        app_name: '%env(APP_NAME)%'
```

## Notifier

```yaml
# config/packages/notifier.yaml
framework:
    notifier:
        chatter_transports:
            slack: '%env(SLACK_DSN)%'
        texter_transports:
            twilio: '%env(TWILIO_DSN)%'
        channel_policy:
            urgent: ['email', 'sms', 'chat']
            high: ['email', 'chat']
            medium: ['email']
            low: ['email']
        admin_recipients:
            - { email: admin@example.com }
```

## Cache

```yaml
# config/packages/cache.yaml
framework:
    cache:
        app: cache.adapter.redis
        default_redis_provider: '%env(REDIS_URL)%'
        pools:
            app.cache.heavy:
                adapter: cache.app
                default_lifetime: 3600
```

## HTTP Client

```yaml
# config/packages/http_client.yaml
framework:
    http_client:
        default_options:
            max_redirects: 5
        scoped_clients:
            api.client:
                base_uri: '%env(API_BASE_URL)%'
                headers:
                    Authorization: 'Bearer %env(API_TOKEN)%'
                retry_failed:
                    max_retries: 3
                    delay: 1000
                    multiplier: 2
```

## Rate Limiter

```yaml
# config/packages/rate_limiter.yaml
framework:
    rate_limiter:
        anonymous_api:
            policy: sliding_window
            limit: 100
            interval: '60 minutes'
        authenticated_api:
            policy: token_bucket
            limit: 1000
            rate: { interval: '15 minutes', amount: 500 }
```

## Lock

```yaml
# config/packages/lock.yaml
framework:
    lock:
        app: '%env(LOCK_DSN)%'         # flock, redis, doctrine
        order: '%env(LOCK_DSN)%'       # lock nomme pour un usage specifique
```

## Workflow

```yaml
# config/packages/workflow.yaml
framework:
    workflows:
        order:
            type: state_machine
            audit_trail:
                enabled: true
            marking_store:
                type: method
                property: status
            supports:
                - App\Entity\Order
            initial_marking: draft
            places:
                - draft
                - pending
                - confirmed
                - shipped
                - delivered
                - cancelled
            transitions:
                confirm:
                    from: draft
                    to: pending
                ship:
                    from: confirmed
                    to: shipped
                deliver:
                    from: shipped
                    to: delivered
                cancel:
                    from: [draft, pending]
                    to: cancelled
```

## Scheduler

```yaml
# Pas de configuration YAML — utilise les attributs PHP :
# #[AsScheduledTask('0 * * * *')]  // Toutes les heures
# #[AsScheduledTask('*/5 * * * *')] // Toutes les 5 minutes
```

## Variables d'environnement communes

```bash
# .env
APP_ENV=dev
APP_SECRET=change-me-in-production
DATABASE_URL="postgresql://user:pass@127.0.0.1:5432/dbname?serverVersion=16&charset=utf8"
MESSENGER_TRANSPORT_DSN=doctrine://default?auto_setup=0
MAILER_DSN=smtp://localhost
REDIS_URL=redis://localhost
LOCK_DSN=flock
```
