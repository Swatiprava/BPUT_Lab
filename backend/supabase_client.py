"""
Supabase client configuration
"""

import os
from supabase import create_client, Client
from dotenv import load_dotenv


ENV_PATH = os.path.join(os.path.dirname(__file__), ".env")


def get_supabase_client() -> Client:
    """Get a Supabase client with the anon key (for public operations)."""
    load_dotenv(dotenv_path=ENV_PATH, override=True)
    url = os.getenv("SUPABASE_URL", "")
    key = os.getenv("SUPABASE_KEY", "")
    if not url or "your_supabase" in url or not url.startswith("http"):
        raise ValueError(f"Invalid SUPABASE_URL configured in backend/.env: '{url}'")
    return create_client(url, key)


def get_supabase_admin() -> Client:
    """Get a Supabase client with the service role key (for admin operations)."""
    load_dotenv(dotenv_path=ENV_PATH, override=True)
    url = os.getenv("SUPABASE_URL", "")
    key = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "") or os.getenv("SUPABASE_KEY", "")
    if not url or "your_supabase" in url or not url.startswith("http"):
        raise ValueError(f"Invalid SUPABASE_URL configured in backend/.env: '{url}'")
    return create_client(url, key)


