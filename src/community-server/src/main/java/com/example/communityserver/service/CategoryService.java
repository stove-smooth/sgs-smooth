package com.example.communityserver.service;

import com.example.communityserver.domain.Category;
import com.example.communityserver.domain.CategoryMember;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.CommunityMember;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.dto.request.*;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CategoryRepository;
import com.example.communityserver.repository.CommunityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CategoryService {

    private final CommunityRepository communityRepository;
    private final CategoryRepository categoryRepository;

    @Transactional
    public void createCategory(Long userId, CreateCategoryRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        Category firstCategory = getFirstCategory(community);

        List<CategoryMember> members = new ArrayList<>();
        if (!request.isPublic()) {
            validateMemberId(community, request.getMembers());
            if (!Objects.isNull(request.getMembers())) {
                members = request.getMembers().stream()
                        .map(CategoryMember::new)
                        .collect(Collectors.toList());
            }
            members.add(new CategoryMember(userId));
        }

        Category newCategory = Category.createCategory(
                request.getName(),
                request.isPublic(),
                firstCategory,
                members
        );

        categoryRepository.save(newCategory);
    }

    private Category getFirstCategory(Community community) {
        return community.getCategories().stream()
                .filter(c -> c.isFirstNode() && c.getStatus().equals(CommonStatus.NORMAL))
                .findFirst().orElse(null);
    }

    private void validateMemberId(Community community, List<Long> memberIds) {
        if (!Objects.isNull(memberIds)) {
            List<Long> communityMemberUserIds = community.getMembers().stream()
                    .filter(communityMember -> communityMember.getStatus().equals(CommunityMemberStatus.NORMAL))
                    .map(CommunityMember::getUserId)
                    .collect(Collectors.toList());

            for (Long memberId: memberIds) {
                if (!communityMemberUserIds.contains(memberId))
                    throw new CustomException(NON_VALID_USER_ID_IN_COMMUNITY);
            }
        }
    }

    @Transactional
    public void editName(Long userId, EditNameRequest request) {

        Category category = categoryRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        isAuthorizedMember(category, userId);

        category.setName(request.getName());
    }

    private void isAuthorizedMember(Category category, Long userId) {
        if (!category.isPublic()) {
            boolean isAuthorized = category.getMembers().stream()
                    .filter(member -> member.isStatus())
                    .map(CategoryMember::getUserId)
                    .collect(Collectors.toList())
                    .contains(userId);

            if (!isAuthorized)
                throw new CustomException(NON_AUTHORIZATION);
        }
    }

    @Transactional
    public void locateCategory(Long userId, LocateCategoryRequest request) {

        Category target = categoryRepository.findById(request.getCategoryId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        isAuthorizedMember(target, userId);

        Community community = target.getCommunity();
        List<Category> categories = community.getCategories().stream()
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .collect(Collectors.toList());

        Category first = getFirstCategory(community);

        Category before = null;
        if (request.getNextNode().equals(0L)) {
            if (target.equals(first))
                throw new CustomException(ALREADY_LOCATED);
        } else {
            before = categories.stream()
                    .filter(c -> c.getId().equals(request.getNextNode()))
                    .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_NEXT_NODE));

            if (!Objects.isNull(before.getNextNode())) {
                if (before.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED);
            }
        }

        target.locate(before, first);
    }

    @Transactional
    public void deleteCategory(Long userId, Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        isAuthorizedMember(category, userId);
        category.delete();
    }

    @Transactional
    public void inviteMember(Long userId, InviteCategoryRequest request) {
        Category category = categoryRepository.findById(request.getCategoryId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        isAuthorizedMember(category, userId);

        if (category.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        isMemberInCommunity(category.getCommunity(), request.getMemberId());
        isContains(category, request.getMemberId());

        category.addMember(new CategoryMember(request.getMemberId()));
    }

    private void isMemberInCommunity(Community community, Long memberId) {
        boolean isMember = community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList())
                .contains(memberId);
        if (!isMember)
            throw new CustomException(NON_VALID_USER_ID_IN_COMMUNITY);
    }

    private void isContains(Category category, Long memberId) {
        boolean isContains = category.getMembers().stream()
                .filter(member -> member.isStatus())
                .map(CategoryMember::getUserId)
                .collect(Collectors.toList())
                .contains(memberId);
        if (isContains)
            throw new CustomException(ALREADY_INVITED);
    }

    @Transactional
    public void deleteMember(Long userId, Long categoryId, Long memberId) {
        Category category = categoryRepository.findById(categoryId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        if (category.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        isAuthorizedMember(category, userId);

        CategoryMember deleteMember = category.getMembers().stream()
                .filter(member -> member.getUserId().equals(memberId))
                .filter(member -> member.isStatus())
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));

        deleteMember.setStatus(false);
    }
}
