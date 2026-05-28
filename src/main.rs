use std::process::ExitCode;

fn main() -> ExitCode {
    if let Err(err) = boreal::run(std::io::stdout()) {
        eprintln!("boreal: {err}");
        return ExitCode::FAILURE;
    }

    ExitCode::SUCCESS
}
