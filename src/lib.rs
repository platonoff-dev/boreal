use std::io::{self, Write};

const GREETING: &str = "hello from boreal";

pub fn run(mut stdout: impl Write) -> io::Result<()> {
    writeln!(stdout, "{GREETING}")
}

#[cfg(test)]
mod tests {
    use super::run;

    #[test]
    fn run_writes_greeting() {
        let mut stdout = Vec::new();

        run(&mut stdout).expect("write greeting");

        assert_eq!(stdout, b"hello from boreal\n");
    }
}
