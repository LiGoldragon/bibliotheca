# annas-archive

Rust client library for [Anna's Archive](https://annas-archive.gd/) — search
and retrieve books, papers, and documents from the world's largest open library
index.

## Usage

```rust
use annas_archive::{Client, SearchOptions};

let client = Client::new();
let response = client.search(SearchOptions::new("category theory")).await?;

for result in &response.results {
    println!("{} — {} ({:?})", result.title,
        result.author.as_deref().unwrap_or("?"),
        result.format);
}
```

## API key

`search()` works without authentication. `details()` and `download_url()`
require a **secret key** with JSON API access, which is granted to
donors.

1. Go to [annas-archive.gd/donate](https://annas-archive.gd/donate)
2. Donate via cryptocurrency, Amazon gift card, Cash App, or Alipay
3. Your **secret key** (with JSON API access) is in Account Settings
4. Pass it to the client:

```rust
let client = Client::with_api_key("your-secret-key");
let details = client.details(&Md5::from("abc123")).await?;
let download = client.download_url(DownloadRequest::new("abc123")).await?;
```

Without a key, these methods return `Error::KeyRequired`.
The free account secret key (from registration) does not include
JSON API access.

## Domain failover

Anna's Archive domains change frequently due to legal pressure. The client
tries each configured domain in order. Current defaults: `annas-archive.gd`,
`annas-archive.gs`.

If all defaults stop resolving, find current mirrors and override:

```rust
use annas_archive::{Client, Config};

let client = Client::from_config(Config {
    domains: vec!["annas-archive.newdomain".into()],
    ..Config::default()
});
```

## MCP server

The crate includes an MCP server binary for use with Claude and other
MCP clients.

```sh
cargo build
```

### Direct (no VPN)

```json
{
  "mcpServers": {
    "annas-archive": {
      "command": "/path/to/annas-archive/target/debug/annas-archive",
      "env": { "RUST_LOG": "info" }
    }
  }
}
```

### Through criome-rt jail (ISP censorship bypass)

If your ISP blocks Anna's Archive, use
[criome-rt](https://github.com/LiGoldragon/criome-rt) to run the MCP
server inside a WireGuard network namespace:

```json
{
  "mcpServers": {
    "annas-archive": {
      "command": "sudo",
      "args": [
        "criome-rt",
        "/path/to/jail-config.json",
        "/path/to/annas-archive/target/debug/annas-archive"
      ],
      "env": { "RUST_LOG": "info" }
    }
  }
}
```

See the criome-rt README for jail configuration and NordVPN setup.

## License

MIT
