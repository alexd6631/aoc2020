use itertools::Itertools;
use eyre::{Result, WrapErr, ContextCompat};


fn main() -> Result<()> {
    let input = include_str!("../../data/day1/data-1.txt");

    let result = compute1(input)?;
    println!("{}", result);
    let result2 = compute2(input)?;
    println!("{}", result2);

    Ok(())
}

fn compute1(input: &str) -> Result<u32> {
    let input: Vec<u32> = parse_input(input)?;
    input.iter()
        .copied()
        .tuple_combinations()
        .find(|(a, b)| a + b == 2020)
        .map(|(a, b)| a * b)
        .context("result not found")
}

fn compute1_generic(input: &str) -> Result<u32> {
    let input: Vec<u32> = parse_input(input)?;
    compute_generic(&input, 2).context("result not found")
}

fn compute2(input: &str) -> Result<u32> {
    let input: Vec<u32> = parse_input(input)?;
    input.iter()
        .copied()
        .tuple_combinations()
        .find(|(a, b, c)| a + b + c == 2020)
        .map(|(a, b, c)| a * b * c)
        .context("result not found")
}

fn compute2_gen(input: &str) -> Result<u32> {
    let input: Vec<u32> = parse_input(input)?;
    compute_generic(&input, 3).context("result not found")
}

fn parse_input(input: &str) -> Result<Vec<u32>> {
    input.lines()
        .map(|line| line.parse().with_context(|| format!("Unparseable line: {:?}", line)))
        .collect()
}

fn compute_generic(list: &[u32], n: usize) -> Option<u32> {
    list.iter()
        .copied()
        .combinations(n)
        .find(|v| v.iter().sum::<u32>() == 2020)
        .map(|v| v.iter().product())
}

#[cfg(test)]
mod tests {
    use crate::{compute1, compute2};

    #[test]
    fn test_compute1() {
        let result = compute1(include_str!("../../data/day1/sample.txt")).unwrap();

        assert_eq!(result, 514_579);
    }

    #[test]
    fn test_compute2() {
        let result = compute2(include_str!("../../data/day1/sample.txt")).unwrap();

        assert_eq!(result, 241_861_950);
    }
}