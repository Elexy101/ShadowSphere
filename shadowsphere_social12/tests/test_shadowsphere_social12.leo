// The 'test_shadowsphere_social12' test program.
import shadowsphere_social12.aleo;
program test_shadowsphere_social12.aleo {
    @test
    script test_it() {
        let result: u32 = shadowsphere_social12.aleo/main(1u32, 2u32);
        assert_eq(result, 3u32);
    }

    @test
    @should_fail
    transition do_nothing() {
        let result: u32 = shadowsphere_social12.aleo/main(2u32, 3u32);
        assert_eq(result, 3u32);
    }

    @noupgrade
    async constructor() {}
}
