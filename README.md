# Greeter

Greeter is a hello world style example app to help introduce the core concepts of the [Phoenix Framework](https://www.phoenixframework.org/) written in [Elixir](https://elixir-lang.org/).

Built using Elixir 1.11 and Phoenix 1.5.5.

## Audience and Expectations

This tutorial assumes no previous Elixir experience.

END IMAGE

## TODO:

- [ ] Add images. 

## Episode Notes

Since this is a hello world style app we'll quickly review some Elixir basics.

### Install Elixir

Installing Elixir on macOS using [Homebrew](https://brew.sh/) could be easy as:

    $ brew install elixir

See the Elixir website for more [installation options](https://elixir-lang.org/install.html) if you need them.

You can check your currently installed version of Elixir with: 

    $ elixir -v
    Erlang/OTP 23 [erts-11.1.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]
    Elixir 1.11.0 (compiled with Erlang/OTP 23)

To get Phoenix running we'll need a few more things. The following is a terse list of the installation needs. For a more detailed walkthrough, see the official [Phoenix Installation](https://hexdocs.pm/phoenix/installation.html) guide. 

### Install Mix and Hex

To create and manage new Elixir projects you'll use a command line tool called `mix`. Mix is a build tool that ships with Elixir and provides tasks for creating, compiling, and testing your application. 

Mix itself works closely with the Hex package manager as a source for your project dependencies. You can verify that hex is setup with:

    $ mix local.hex

With Elixir, Mix and Hex all setup you are now ready to install the Phoenix application generator:

    $ mix archive.install hex phx_new 1.5.5

### Install Node.js

Being a web application, your Phoenix app will need to publish assets like CSS and JavaScript. To help deploy these, Phoenix will lean on Node.js tooling and so you'll need to make sure `node` is available. Like before, on macOS using Homebrew this could be as simple as:

    $ brew install node

For more Node.js installation options, see [their website](https://nodejs.org/en/download/).

### No PostgreSQL Install

Many of the Elixir Phoenix apps you'll encounter utilize [PostgreSQL](https://www.postgresql.org/) for storage and so eventually you'll want to have it installed. However, to keep things simple, this example will avoid database use and so no PostgreSQL installation is necessary.

### Generating the Project

We are ready to use the `mix` tool to generate our Phoenix app. Since we are not going to use any database storage we will include a flag to skip that dependency in the generated project. For more flag options see [the docs](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html).

    $ mix phx.new greeter --no-ecto

When asked if you would like to install dependencies, answer Yes.

Change your path into the newly created project directory and start the local development server:

    $ cd greeter
    $ mix phx.server

Visit <http://localhost:4000> and you should see the default Phoenix app page.

IMAGE

### Add a new welcome route.

The goal of this project is to add a new welcome page and have that page display a customized greeting message. If you edit the URL of your browser to <http://localhost:4000/welcome/amy> you'll notice the following error:

IMAGE

This error page is basically Phoenix saying it does not know how to answer that URL request. It tries to be helpful and displays the requests (aka the routes) that it does know about, and as expected our `welcome` URL is not one of them. 

To add a new route you'll want to edit the `routes.ex` file located at: `lib/greeter_web/routes.ex`. Add a new `welcome` route.

#### Listing 1: Add a new welcome route that captures a name. (`router.ex`)

```diff
  scope "/", GreeterWeb do
    pipe_through :browser

    get "/", PageController, :index

+   get "/welcome/:name", WelcomeController, :index
  end
```

This code tells Phoenix that when an HTTP GET request comes in that starts with `/welcome/` run the code inside the `WelcomeController` using the  `index` function. Also, whatever content was in the URL after the last backslash put into a parameter called `name`.

To get our new page working we'll need to add a few files: a controller called `WelcomeController`, a view called `WelcomeView` and a template for the `index` action that defines the HTML we send back to the browser.

Create the three files using the code listings below.

`/lib/greeter_web/controllers/welcome_controller.ex`

### Listing 2: Create a `WelcomeController`. (`welcome_controller.ex`)

```elixir
defmodule GreeterWeb.WelcomeController do
  use GreeterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
```

`/lib/greeter_web/views/welcome_view.ex`

### Listing 3: Create a `WelcomeView`. (`welcome_view.ex`)

```elixir
defmodule GreeterWeb.WelcomeView do
  use GreeterWeb, :view
end
```

### Listing 4: Create a `index` page template. (`index.html.eex`)

```html
<h1>Welcome!</h1>
```

The Phoenix app should detect the changes to the router and the other new files, but if you run into trouble use control-C to stop the server and the restart it with `mix phx.server`.

Now, when you load <http://localhost:4000/welcome/amy> you should see the new page with a welcome header. The header still lacks our name, but progress!

You may have noticed the `_params` in that index function. This second argument of `index` is what would normally hold the parameters of the request but since those values were not used in our first iteration we prefixed it with an underscore as a way of saying we are not using this. We could have also used an underscore by itself, but prefixing a more meaningful name can help code readability.

Now that we do want to use the params remove the underscore. The type of `params` is actually an [Elixir Map](https://hexdocs.pm/elixir/Map.html) and so we can use some `[]` bracket syntax to get at the name value within. Bind a local variable `name` to the name in the params map. Then update the `render` call such that we are passing the name value in.

```diff
- def index(conn, _params) do
-    render(conn, "index.html")
+ def index(conn, params) do
+   name = params["name"]
+   render(conn, "index.html", name: name)
  end
```

Now that render is being told what the `name` is we can update the template to display it. Update the welcome header to include the name:

```diff
- <h1>Welcome!</h1>
+ <h1>Welcome, <%= @name %>!</h1>
```

This syntax is [Embedded Elixir](https://hexdocs.pm/eex/EEx.html) and is what we use to make templates dynamic in Phoenix.

Try loading the test url again: <http://localhost:4000/welcome/amy>

Now it's starting to come together!

> #### A quick note about pattern matching.
> 
> There is a very common code style you'll see in everyday Elixir/Phoenix code where the `index` function would look like:
> ```elixir
> def index(conn, %{"name" => name}) do
>   render(conn, "index.html", name: name)
> end
> ```
>
> This style uses [Pattern Matching](https://elixir-lang.org/getting-started/pattern-matching.html). Pattern Matching is a core Elixir pattern and is beyond the scope of this hello world tutorial. I justed wanted to point out that the tutorial code you wrote while valid does not really follow the community norms you'll see in the wild. Check out the Pattern Matching guide if you want a brief introduction.

There are two other concepts we should explore before finishing up. First is overall code structure and organization and the second is some basic testing.

### Adding Business Domain Code

As you may have noticed, the generated Phoenix project has some opinions about directory structure. So far we've been working in `greeter_web` directory but in a larger app you'll have also have lots of business domain code. A good place for that is the `greeter` directory right next to `greeter_web`. Since this app is pretty basic we'll keep the business domain stuff pretty simple and create a formatter module to make names look nicer. It's not much but it will help demo how code can be separated.

Create a new `NameFormatter` module with a simple `format` function that will capitalize our names.

`/lib/greeter/name_formatter.ex`

### Listing ?: Create a `NameFormatter` module. (`name_formatter.ex`)

```elixir
defmodule Greeter.NameFormatter do
  def format(name) do
    String.capitalize(name)
  end
end
```

Before we get to integrating this new lovely formatter, let's add some tests to verify our expectations. One of the `mix` tasks is to run all of our tests, and the default Phoenix project generator made a few for you. 

    $ mix test
    Compiling 1 file (.ex)
    .....
    
    Finished in 0.1 seconds
    5 tests, 0 failures

Let's add a new test file for our `NameFormatter`. Generally it's a good idea to mirror each major type in the app with a similarly named test file. Under the `test` directory at the root of your project, find the `greeter` directory and then make a test file for the `NameFormatter` module: 

`test/greeter/name_formatter_test.exs`

### Listing ?: Create a `NameFormatterTest` file. (`name_formatter_test.exs`)

```elixir
defmodule Greeter.NameFormatterTest do
  use ExUnit.Case, async: true

  alias Greeter.NameFormatter

  describe "format/1" do
    test "works with simple name" do
      assert NameFormatter.format("mike") == "Mike"
    end
  end
end
```

> Note: The test file ends in `.exs` while all the previous code files you made ended in `.ex`. 
> 
> `.ex` is for compiled code, `.exs` is for interpreted code.
>
> [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) tests, for example, are in `.exs` files so that you don't have to recompile every time you make a change to your tests. If you're writing scripts or tests, use `.exs` files. Otherwise, just use `.ex` files and compile your code.

Now re-run `mix test` to verify the tests work. Put it a failing string to see how it fails. 

If you want to just test this since file use:

    $ mix test test/greeter/name_formatter_test.exs

Testing is obviously a deeper topic than we can cover in a hello world tutorial, but just knowing it is well integrated into the tooling is good to know.

Now that we have a working formatter, let's update our controller to use it:

```diff
  def index(conn, params) do
    name = params["name"]
-   render(conn, "index.html", name: name)
+   formatted_name = Greeter.NameFormatter.format(name)
+   render(conn, "index.html", name: formatted_name)
  end
```

And add a test to verify the new controller behavior:

`test/greeter_web/controllers/welcome_controller_test.exs`

### Listing ?: Create a `WelcomeControllerTest` file. (`welcome_controller_test.exs`)

```elixir
defmodule GreeterWeb.WelcomeControllerTest do
  use GreeterWeb.ConnCase

  test "GET /welcome/gus", %{conn: conn} do
    conn = get(conn, "/welcome/gus")
    assert html_response(conn, 200) =~ "Welcome, Gus!"
  end
end
```
You can verify the new behavior by rerunning the tests:

    $ mix test

Or rebooting the local dev server:

    $ mix phx.server

END IMAGE

### Conclusion

Hello world is a classic milestone for anyone learning a new technology. Congrats on your first steps into Phoenix!

You've accomplished a lot of great things today, including:

* Installing Elixir and Phoenix.
* Generating a new project.
* Adding a custom route, controller and template.
* Building out some simple business domain behavior.
* Verifying your work for today and tomorrow through tests!

For more learning Elixir resources check out the language website:

<https://elixir-lang.org/learning.html>

For more on learning Phoenix check out the resources indexed here:

<https://hexdocs.pm/phoenix/community.html>

If you have any feedback on this tutorial or want to see more, please reach out to: <mike@mikezornek.com>.

Thanks for your interest and best of luck using Phoenix!