# SubjectManager

## Setup

### Prerequisites

Install ASDF (if using macOS):
  ```bash
  brew install asdf
  ```

### ASDF Dependencies

Run the following commands to install required language versions:

```bash
asdf plugin-add elixir
asdf plugin-add erlang
asdf plugin-add nodejs
asdf install
```

### Phoenix Setup

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Development admin account

After running the seeds, you can log in with:

```text
Email: test@admin.com
Password: 1234
```

This account is intended for local development only.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
