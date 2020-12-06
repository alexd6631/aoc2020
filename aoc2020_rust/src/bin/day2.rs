use std::ops::RangeInclusive;
use eyre::{Result, ContextCompat};
use itertools::Itertools;


#[derive(Debug, Eq, PartialEq)]
struct Policy {
    occurences: RangeInclusive<usize>,
    char: u8
}

impl Policy {
    pub fn new(occurences: RangeInclusive<usize>, char: u8) -> Self {
        Policy { occurences, char }
    }

    fn check_password(&self, password: &str) -> bool {
        let count = password.bytes().filter(|c| *c == self.char).count();

        self.occurences.contains(&count)
    }

    fn check_password_2(&self, password: &str) -> bool {
        let bytes = password.as_bytes();
        let start_char = bytes[*self.occurences.start() - 1];
        let end_char = bytes[*self.occurences.end() - 1];

        (start_char == self.char) ^ (end_char == self.char)
    }
}

fn parse_line(line: &str) -> Result<(Policy, String)> {
    let (occurence, char, password) = line.split(" ")
        .collect_tuple()
        .context("Cannot parse line")?;

    let (start, end) = occurence
        .split("-")
        .collect_tuple()
        .context("Cannot extract occurence")?;

    let start: usize = start.parse()?;
    let end: usize = end.parse()?;

    let char = *char.as_bytes().get(0).context("Cannot extract char")?;

    Ok((Policy::new(start..=end, char), password.to_string()))
}

fn main() -> Result<()> {
    let input = include_str!("../../data/day2/data.txt");

    let pwds = parse_input(input)?;

    let part1 = compute1(&pwds);
    let part2 = compute2(&pwds);

    println!("{}", part1);
    println!("{}", part2);
    Ok(())
}

fn compute1(pwds: &[(Policy, String)]) -> usize {
    pwds.iter()
        .filter(|(pol, pwd)| pol.check_password(pwd))
        .count()
}

fn compute2(pwds: &[(Policy, String)]) -> usize {
    pwds.iter()
        .filter(|(pol, pwd)| pol.check_password_2(pwd))
        .count()
}

fn parse_input(input: &str) -> Result<Vec<(Policy, String)>> {
    input.lines()
        .map(|l| parse_line(l))
        .collect()
}


#[cfg(test)]
mod tests {
    use crate::{parse_line, Policy, compute1, parse_input, compute2};

    #[test]
    fn test_parse_line() {
        let sample_line = "11-14 b: bbbbbbbbbbbbbbb";
        let res = parse_line(sample_line);

        println!("{:?}", res);

        assert_eq!(
            res.unwrap(),
            (Policy::new(11..=14, 'b' as u8), "bbbbbbbbbbbbbbb".chars().collect())
        )
    }

    #[test]
    fn test_check_policy() {
        let (policy, pwd) = parse_line("1-3 a: abcde").unwrap();
        assert_eq!(true, policy.check_password(&pwd));

        let (policy, pwd) = parse_line("1-3 b: cdefg").unwrap();
        assert_eq!(false, policy.check_password(&pwd));

        let (policy, pwd) = parse_line("2-9 c: ccccccccc").unwrap();
        assert_eq!(true, policy.check_password(&pwd));
    }

    #[test]
    fn test_compute1() {
        let input = "1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc";
        let res = compute1(&parse_input(input).unwrap());
        assert_eq!(2, res);
    }

    #[test]
    fn test_compute2() {
        let input = "1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc";
        let res = compute2(&parse_input(input).unwrap());
        assert_eq!(1, res);
    }
}