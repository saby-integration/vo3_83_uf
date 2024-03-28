set file=version.bin

for /f "tokens=1,2,3 delims=." %%a in (%file%) do (
    set "PART1=%%a"
    set "PART2=%%b"
)

set "branch=rc-%PART1%.%PART2%"
cd %~dp0

git clone https://git.sbis.ru/integration/vo3_core core
git clone https://git.sbis.ru/integration/blockly_saby_blocks_1c BlocklySabyBlocks
git clone https://git.sbis.ru/integration/blockly_executor_1c BlocklyExecutor

git reset --hard origin/%branch%
git pull origin %branch%
git checkout %branch%
git pull origin %branch%

cd %~dp0core
git reset --hard origin/%branch%
git pull origin %branch%
git checkout %branch%
git pull origin %branch%

cd %~dp0BlocklySabyBlocks
git reset --hard origin/%branch%
git pull origin %branch%
git checkout %branch%
git pull origin %branch%

cd %~dp0BlocklyExecutor
git reset --hard origin/%branch%
git pull origin %branch%
git checkout %branch%
git pull origin %branch%

@pause