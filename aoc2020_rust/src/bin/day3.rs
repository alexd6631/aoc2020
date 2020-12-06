use itertools::Itertools;
use itertools::__std_iter::successors;

#[derive(Debug)]
struct Grid(Vec<Vec<bool>>);

impl Grid {
    fn n_lines(&self) -> usize {
        self.0.len()
    }

    fn is_tree(&self, pos: (usize, usize)) -> Option<bool> {
        let line = self.0.get(pos.1)?;
        Some(line[pos.0 % line.len()])
    }

    fn is_tree2(&self, pos: (usize, usize)) -> bool {
        let line = &self.0[pos.1];
        line[pos.0 % line.len()]
    }
}


fn parse_grid(input: &str) -> Grid {
    let data = input.lines()
        .map(|line| line.chars().map(|c| c == '#').collect_vec())
        .collect_vec();

    Grid(data)
}

fn main() {
    let grid = parse_grid(include_str!("../../data/day3/data.txt"));
    println!("{:?}", compute1(&grid));
    println!("{:?}", compute2(&grid));
}

fn compute1(grid: &Grid) -> usize {
    compute(grid, (3, 1))
}

fn compute2(grid: &Grid) -> usize {
    let slopes: Vec<(usize, usize)> = vec![
        (1, 1),
        (3, 1),
        (5, 1),
        (7, 1),
        (1, 2)
    ];

    slopes.iter().map(|s| compute(grid, *s)).product()
}

fn compute_old(grid: &Grid, slope: (usize, usize)) -> u32 {
    let mut pos = (0usize, 0usize);
    let mut count = 0;
    while let Some(isTree) = grid.is_tree(pos) {
        if isTree { count += 1 }
        pos.0 += slope.0;
        pos.1 += slope.1;
    }
    count
}

fn compute(grid: &Grid, slope: (usize, usize)) -> usize {
    get_positions(grid.n_lines(), slope)
        .filter(|p| grid.is_tree2(*p))
        .count()
}

fn get_positions(n_lines: usize, slope: (usize, usize)) -> impl Iterator<Item=(usize, usize)> {
    successors(Some((0, 0)), move |pos| {
        let new_pos = (pos.0 + slope.0, pos.1 + slope.1);
        if new_pos.1 < n_lines { Some(new_pos) } else { None }
    })
}

#[cfg(test)]
mod tests {
    use crate::{compute1, parse_grid, compute2};

    #[test]
    fn test_compute1() {
        let res = compute1(&parse_grid(include_str!("../../data/day3/sample.txt")));
        assert_eq!(7, res);
    }

    #[test]
    fn test_compute2() {
        let res = compute2(&parse_grid(include_str!("../../data/day3/sample.txt")));
        assert_eq!(336, res);
    }
}