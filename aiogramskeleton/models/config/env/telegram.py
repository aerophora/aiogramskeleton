from pydantic import SecretStr

from .base import EnvSettings


class TelegramConfig(EnvSettings, env_prefix="TELEGRAM_"):
    bot_token: SecretStr
    locales: list[str | None]
    admin_ids: list[int | None]
    drop_pending_updates: bool
    use_webhook: bool
    reset_webhook: bool
    webhook_path: str
    webhook_secret: SecretStr
