## Условия

Есть репозиторий с инфраструктурой на `terragrunt`. Задача в сроки которые ты установишь себе сам, но, желательно, не больше двух суток, внести правки, отметить их в ##Todo, сделать `git commit` и `git push`.

Есть 3 окружения:

1. `development`
2. `staging`
3. `production`

Есть два модуля, при помощи которых мы разворачиваем наши `NodeJS` приложения:

1. Модуль `gcp-gke-deployment`. Он содержит `deployment` и `hpa`.
2. Модуль `gcp-gke-deployment-service` содержит то же, что и предыдущий, но с дополнительными `resource` вроде `ingress`, `managed_ssl_certificate` и так далее.

Список `deployment`, которые используют вышеперечисленные модули:

1. `api` выступает в качестве `API Gateway`, взаимодействие извне с остальными происходит именно через него.
2. `auth` авторизация.
3. `contract` взаимодействие с блокчейном.
4. `dbs` базы данных.
5. `notify` уведомления.
6. `lab` для разработчиков. Работает только в `development` окружении. Он, так же как и `api` торчит наружу.

Правильно, чтобы`gcp-gke-deployment-service` наследовал `gcp-gke-deployment` , по этому эта задача в списке:

## ToDo

[ ] Сделать переиспользуемым модуль `gcp-gke-deployment` в `gcp-gke-deployment-service`.
[ ]
[ ]
[ ]

Заполни ещё хотя бы 3 пункта выше
