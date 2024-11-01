from pydantic import SecretStr

from .base import EnvSettings


class TelegramConfig(EnvSettings, env_prefix="TELEGRAM_"):
    bot_token: SecretStr
    locales: list[str]
    admin_ids: list[int]
    drop_pending_updates: bool
    use_webhook: bool
    reset_webhook: bool
    webhook_path: str
    webhook_secret: SecretStr
